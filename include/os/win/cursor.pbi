;\\
XIncludeFile "../cursors.pbi"

Module Cursor 
  Global OldProc
  
  Procedure   Proc(hWnd, uMsg, wParam, lParam)
    Protected result
    ; oldproc = GetProp_(hWnd, "__oldproc")
    
    Protected *cursor._s_cursor
    
    Select uMsg
;       Case #WM_NCDESTROY
;         ; RemoveProp_(hwnd, "__oldproc")
;       ; RemoveProp_(hwnd, "__cursor")
      
      Case #WM_SETCURSOR
        ; Debug " -  #WM_SETCURSOR "+wParam +" "+ lParam
        Cursor::Change( wParam, 1 )
        
      Default
        result = CallWindowProc_(OldProc, hWnd, uMsg, wParam, lParam)
    EndSelect
    
    ProcedureReturn result
  EndProcedure
  
  Global NewMap images.i()
  
  ;-\\
  Procedure   Image( type.i = 0 )
    Protected image
    
    If type = #PB_Cursor_Drop
      image = CatchImage( #PB_Any, ?add, 601 )
    ElseIf type = #PB_Cursor_Drag
      image = CatchImage( #PB_Any, ?copy, 530 )
    EndIf
    
    If Not image
      image = CreateImage( #PB_Any, 16, 16, 32, #PB_Image_Transparent )
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
    
    ProcedureReturn image
  EndProcedure
   
  Procedure New( icursor.i )
    If Not FindMapElement(images(), Str(icursor))
      AddMapElement(images(), Str(icursor))
      images() = Create(ImageID(Image( icursor )))
    EndIf
    
    ProcedureReturn images()
  EndProcedure
  
  Procedure   Free(hCursor.i)
    Debug "cursor-free "+hCursor
    
    If hCursor >= 0 And hCursor <= 255
      If FindMapElement(images(), Str(hCursor))
        DeleteMapElement(images());, Str(hCursor))
      EndIf
    Else
      If MapSize(images())
        PushMapPosition(images())
        ForEach images()
          If hCursor = images()
            DeleteMapElement(images())
          EndIf
        Next
        PopMapPosition(images())
      EndIf
      ProcedureReturn DestroyCursor_( hCursor )
    EndIf
  EndProcedure
  
  Procedure   isHiden()
    Protected cursor_info.CURSORINFO 
		cursor_info\cbSize = SizeOf(CURSORINFO)
		GetCursorInfo_(@cursor_info)
		ProcedureReturn Bool(cursor_info\flags & #CURSOR_SHOWING)
	EndProcedure
  
  Procedure   Hide(state.b)
    ProcedureReturn ShowCursor_(state)
  EndProcedure
    
  Procedure.i Create(ImageID.i, x.l = 0, y.l = 0)
    Protected *create_icon, cursor_info.ICONINFO
    cursor_info\fIcon = 0
    cursor_info\xHotspot = x 
    cursor_info\yHotspot = y 
    cursor_info\hbmMask = ImageID
    cursor_info\hbmColor = ImageID
    *create_icon = CreateIconIndirect_( @cursor_info ) 
    If Not *create_icon : *create_icon = ImageID : EndIf
    ProcedureReturn *create_icon
  EndProcedure
  
  Procedure   Change( GadgetID.i, state.b )
    Protected result, *cursor._s_cursor = GetProp_(GadgetID, "__cursor")
    If *cursor And
       *cursor\hcursor
      
      ; reset
      If state = 0 
        ; SetClassLongPtr_( *cursor\windowID, #GCL_HCURSOR, LoadCursor_(0,#IDC_ARROW) )
        result = SetCursor_( LoadCursor_(0,#IDC_ARROW) )
      EndIf
      
      ; set
      If state = 1 
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
        CompilerIf #PB_Compiler_IsMainFile
          Debug "changeCursor"
        CompilerEndIf
      EndIf
    EndIf
  EndProcedure
  
  Procedure   Set(Gadget.i, icursor.i)
    ; Debug ""+Gadget +" "+ icursor
    
    If Gadget >= 0
      Protected *cursor._s_cursor
      Protected GadgetID = GadgetID(Gadget)
      CompilerIf #PB_Compiler_IsMainFile
        Debug "setCursor"
      CompilerEndIf
      
      *cursor = GetProp_(GadgetID, "__cursor")
      
      If Not *cursor
        *cursor = AllocateStructure(_s_cursor)
        *cursor\windowID = ID::GetWindowID(GadgetID)
        SetProp_(GadgetID, "__cursor", *cursor) 
        ;
        OldProc = SetWindowLong_(GadgetID, #GWL_WNDPROC, @Proc())
        ; SetProp_(GadgetID,"__oldproc", SetWindowLongPtr_(GadgetID,#GWL_WNDPROC,@Proc()))
      EndIf
      
      If *cursor\icursor <> icursor
        *cursor\icursor = icursor
        
        If icursor >= 0 And icursor <= 255
          Select icursor
            Case #PB_Cursor_Invisible : *cursor\hcursor =- 1
            Case #PB_Cursor_Default   : *cursor\hcursor = LoadCursor_(0,#IDC_ARROW)
            Case #PB_Cursor_IBeam     : *cursor\hcursor = LoadCursor_(0,#IDC_IBEAM)
            Case #PB_Cursor_Denied    : *cursor\hcursor = LoadCursor_(0,#IDC_NO)
            Case #PB_Cursor_Cross     : *cursor\hcursor = LoadCursor_(0,#IDC_CROSS)
            Case #PB_Cursor_Hand      : *cursor\hcursor = LoadCursor_(0,#IDC_HAND)
              
            Case #PB_Cursor_Up        ;: *cursor\hcursor = LoadCursor_(0,#IDC_SIZENS)
              Case #PB_Cursor_UpDown       
              
              
              Define x = 0
              Define y = 0
              Define width = 16
              Define height = 16;7
              Define fcolor = $ffFFFFFF
              Define bcolor = $ff000000
              Define img = CreateImage(#PB_Any, width, height, 32, #PB_Image_Transparent)
              Macro DrawUp2(x, y, size, bcolor, fcolor)
                Line(x+7, y, 2, 1, fcolor)                                                                                         ; 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                Plot(x+6, y+1, fcolor ) : Line(x+7, y+1, 2, 1, bcolor) : Plot(x+9, y+1, fcolor )                                   ; 0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0
                Plot(x+5, y+2, fcolor ) : Line(x+6, y+2, 4, 1, bcolor) : Plot(x+10, y+2, fcolor )                                  ; 0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0
                Plot(x+4, y+3, fcolor ) : Line(x+5, y+3, 6, 1, bcolor) : Plot(x+11, y+3, fcolor )                                  ; 0,0,0,0,0,1,1,1,1,1,1,0,0,0,0,0
                Line(x+4, y+4, 3, 1, fcolor) : Line(x+7, y+4, 2, 1, bcolor) : Line(x+size/2+1, y+4, 3 , 1, fcolor)                 ; 0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0
                Plot(x+size/2-2, y+5, fcolor ) : Line(x+7, y+5, 2, 1, bcolor) : Plot(x+size/2+1, y+5, fcolor )                     ; 0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0
              EndMacro
              Macro DrawCursorSplitterUp2(x, y, width, bcolor, fcolor)
                Line(x, y+6, width/2-1 , 1, fcolor) : Line(x+7, y+6, 2, 1, bcolor) : Line(x+width/2+1, y+6, width/2-1, 1, fcolor)   ; 0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0
                Plot(x, y+7, fcolor ) : Line(x+1, y+7, width-2, 1, bcolor) : Plot(x+width-1, y+7, fcolor )                          ; 0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0
              EndMacro
              If StartDrawing(ImageOutput(img))
                DrawingMode(#PB_2DDrawing_AlphaBlend)
                Box(0,0,OutputWidth(),OutputHeight(), $A9B7B6)
                ; up                                                 
                DrawUp2(x, y, width, bcolor, fcolor)
                DrawCursorSplitterUp2(x,y,width, bcolor, fcolor )
                Plot(x, y+8, fcolor ) : Line(x+1, y+8, width-2, 1, bcolor) : Plot(x+width-1, y+8, fcolor )                          ; 0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0
                Line(x, y + 9, width , 1, fcolor)                                                                                   ; 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                StopDrawing()
              EndIf
              
              *cursor\hcursor = Create(ImageID(img), width/2, height/2)
             
            Case #PB_Cursor_Down      : *cursor\hcursor = LoadCursor_(0,#IDC_SIZENS)
            ;Case #PB_Cursor_UpDown    : *cursor\hcursor = LoadCursor_(0,#IDC_SIZENS)
              
            Case #PB_Cursor_Left      : *cursor\hcursor = LoadCursor_(0,#IDC_SIZEWE)
            Case #PB_Cursor_Right     : *cursor\hcursor = LoadCursor_(0,#IDC_SIZEWE)
            Case #PB_Cursor_LeftRight : *cursor\hcursor = LoadCursor_(0,#IDC_SIZEWE)
              
            Case #PB_Cursor_LeftDownRightUp : *cursor\hcursor = LoadCursor_(0,#IDC_SIZENESW)
            Case #PB_Cursor_LeftUpRightDown : *cursor\hcursor = LoadCursor_(0,#IDC_SIZENWSE)
              
            Case #PB_Cursor_Arrows      : *cursor\hcursor = LoadCursor_(0,#IDC_SIZEALL)
              
            Case #PB_Cursor_Drag : *cursor\hcursor = New( icursor )
            Case #PB_Cursor_Drop : *cursor\hcursor = New( icursor )
              
            Case #PB_Cursor_Grab      : *cursor\hcursor = LoadCursor_(0,#IDC_ARROW)
            Case #PB_Cursor_Grabbing  : *cursor\hcursor = LoadCursor_(0,#IDC_ARROW)
              
          EndSelect 
        Else
          *cursor\hcursor = icursor 
        EndIf
      EndIf
      
      If *cursor\hcursor And 
         GadgetID = mouse::Gadget(*cursor\windowID)
        Change( GadgetID, 1 )
        ProcedureReturn #True
      EndIf
    EndIf
  EndProcedure
  
  Procedure   Get()
    Protected result.i
    Protected cursor_info.CURSORINFO 
    cursor_info\cbSize = SizeOf(CURSORINFO)
    GetCursorInfo_(@cursor_info)
    
    If cursor_info\flags & #CURSOR_SHOWING
      Select cursor_info\hCursor ; GetCursor_()
        Case LoadCursor_(0,#IDC_ARROW) : result = #PB_Cursor_Default
        Case LoadCursor_(0,#IDC_IBEAM) : result = #PB_Cursor_IBeam
        Case LoadCursor_(0,#IDC_NO) : result = #PB_Cursor_Denied
          
        Case LoadCursor_(0,#IDC_HAND) : result = #PB_Cursor_Hand
        Case LoadCursor_(0,#IDC_CROSS) : result = #PB_Cursor_Cross
        Case LoadCursor_(0,#IDC_SIZEALL) : result = #PB_Cursor_Arrows
          
        Case LoadCursor_(0,#IDC_SIZEWE) : result = #PB_Cursor_Up
        Case LoadCursor_(0,#IDC_SIZEWE) : result = #PB_Cursor_Down
        Case LoadCursor_(0,#IDC_SIZEWE) : result = #PB_Cursor_UpDown
          
        Case LoadCursor_(0,#IDC_SIZENS) : result = #PB_Cursor_Left
        Case LoadCursor_(0,#IDC_SIZENS) : result = #PB_Cursor_Right
        Case LoadCursor_(0,#IDC_SIZENS) : result = #PB_Cursor_LeftRight
          
        Case LoadCursor_(0,#IDC_SIZENESW) : result = #PB_Cursor_LeftDownRightUp
        Case LoadCursor_(0,#IDC_SIZENWSE) : result = #PB_Cursor_LeftUpRightDown
          
        Case LoadCursor_(0,#IDC_ARROW) : result = #PB_Cursor_Drop
        Case LoadCursor_(0,#IDC_ARROW) : result = #PB_Cursor_Drag
          
        Case LoadCursor_(0,#IDC_ARROW) : result = #PB_Cursor_Grab
        Case LoadCursor_(0,#IDC_ARROW) : result = #PB_Cursor_Grabbing
          
      EndSelect 
    Else
      result = #PB_Cursor_Invisible
    EndIf
    
    ProcedureReturn result
  EndProcedure
EndModule   

;-
;-\\ example
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseModule constants
  ;UseModule events
  
  Define event
  Define g1,g2
  
  Procedure   DrawCanvasBack(Gadget, color)
    If GadgetType(Gadget) = #PB_GadgetType_Canvas
      StartDrawing(CanvasOutput(Gadget))
      DrawingMode(#PB_2DDrawing_Default)
      Box(0,0,OutputWidth(), OutputHeight(), color)
      StopDrawing()
    EndIf
  EndProcedure
  
  Procedure   DrawCanvasFrame(Gadget, color)
    If GadgetType(Gadget) = #PB_GadgetType_Canvas
      StartDrawing(CanvasOutput(Gadget))
      If GetGadgetState(Gadget)
        DrawImage(0,0, GetGadgetState(Gadget))
      EndIf
      If Not color
        color = Point(10,10)
      EndIf
      If color 
        DrawingMode(#PB_2DDrawing_Outlined)
        Box(0,0,OutputWidth(), OutputHeight(), color)
      EndIf
      StopDrawing()
    EndIf
  EndProcedure
  
  Procedure Resize_2()
    Protected canvas = 2
    ResizeGadget(canvas, #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow()) - GadgetX(canvas)*2, WindowHeight(EventWindow()) - GadgetY(canvas)*2)
  EndProcedure
  
  Procedure Resize_3()
    Protected canvas = 3
    ResizeGadget(canvas, #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow()) - GadgetX(canvas)*2, WindowHeight(EventWindow()) - GadgetY(canvas)*2)
  EndProcedure
  
  Macro GadgetMouseX(_canvas_, _mode_ = #PB_Gadget_ScreenCoordinate)
    ; GetGadgetAttribute(_canvas_, #PB_Canvas_MouseX)
    DesktopMouseX() - GadgetX(_canvas_, _mode_)
    ; WindowMouseX(ID::Window(ID::GetWindowID(GadgetID(_canvas_)))) - GadgetX(_canvas_, #PB_Gadget_WindowCoordinate)  
  EndMacro
  Macro GadgetMouseY(_canvas_, _mode_ = #PB_Gadget_ScreenCoordinate)
    ; GetGadgetAttribute(_canvas_, #PB_Canvas_MouseY)
    DesktopMouseY() - GadgetY(_canvas_, _mode_)
    ; WindowMouseY(ID::Window(ID::GetWindowID(GadgetID(_canvas_)))) - GadgetY(_canvas_, #PB_Gadget_WindowCoordinate)
  EndMacro
  
  Procedure EventHandler(eventobject, eventtype, eventdata)
    Protected window = EventWindow()
    Protected dropx, dropy
    Static deltax, deltay
    
    Select eventtype
      Case #PB_EventType_MouseWheelX
        Debug ""+eventobject + " #PB_EventType_MouseWheelX " +eventdata
        
      Case #PB_EventType_MouseWheelY
        Debug ""+eventobject + " #PB_EventType_MouseWheelY " +eventdata
        
      Case #PB_EventType_DragStart
        deltax = GadgetMouseX(eventobject, #PB_Gadget_WindowCoordinate)
        deltay = GadgetMouseY(eventobject, #PB_Gadget_WindowCoordinate)
        Debug ""+eventobject + " #PB_EventType_DragStart " + "x="+ deltax +" y="+ deltay
        
      Case #PB_EventType_Drop
        dropx = GadgetMouseX(eventobject, #PB_Gadget_ScreenCoordinate)
        dropy = GadgetMouseY(eventobject, #PB_Gadget_ScreenCoordinate)
        Debug ""+eventobject + " #PB_EventType_Drop " + "x="+ dropx +" y="+ dropy
        
      Case #PB_EventType_Focus
        Debug ""+eventobject + " #PB_EventType_Focus " 
        DrawCanvasBack(eventobject, $FFA7A4)
        DrawCanvasFrame(eventobject, $2C70F5)
        
      Case #PB_EventType_LostFocus
        Debug ""+eventobject + " #PB_EventType_LostFocus " 
        DrawCanvasBack(eventobject, $FFFFFF)
        
      Case #PB_EventType_LeftButtonDown
        Debug ""+eventobject + " #PB_EventType_LeftButtonDown " 
        
      Case #PB_EventType_LeftButtonUp
        Debug ""+eventobject + " #PB_EventType_LeftButtonUp " 
        
      Case #PB_EventType_LeftClick
        Debug ""+eventobject + " #PB_EventType_LeftClick " 
        
      Case #PB_EventType_LeftDoubleClick
        Debug ""+eventobject + " #PB_EventType_LeftDoubleClick " 
        
      Case #PB_EventType_MouseEnter
        ;Debug ""+eventobject + " #PB_EventType_MouseEnter " ;+ CocoaMessage(0, WindowID(window), "isActive") 
        DrawCanvasFrame(eventobject, $00A600)
        
      Case #PB_EventType_MouseLeave
        ;Debug ""+eventobject + " #PB_EventType_MouseLeave "
        DrawCanvasFrame(eventobject, 0)
        
      Case #PB_EventType_Resize
        Debug ""+eventobject + " #PB_EventType_Resize " 
        
      Case #PB_EventType_MouseMove
        ;         If DraggedGadget() = 1
        ;           Debug ""+eventobject + " #PB_EventType_MouseMove " 
        ;           ResizeGadget(DraggedGadget(), DesktopMouseX()-deltax, DesktopMouseY()-deltay, #PB_Ignore, #PB_Ignore)
        ;         EndIf
        ;         ;         If DraggedGadget() = 0
        ;         ;           ResizeGadget(DraggedGadget(), DesktopMouseX()-deltax, DesktopMouseY()-deltay, #PB_Ignore, #PB_Ignore)
        ;         ;         EndIf
        
    EndSelect
  EndProcedure
  
  Procedure OpenWindow_(window, x,y,width,height, title.s, flag=0)
    Protected WindowID
    Protected result = OpenWindow(window, x,y,width,height, title.s, flag|#PB_Window_SizeGadget)
    If window >= 0
      WindowID = WindowID(window)
    Else
      WindowID = result
    EndIf
    ;Debug 77
    ;CocoaMessage(0, WindowID, "disableCursorRects")
    ProcedureReturn result
  EndProcedure
  
  Macro OpenWindow(window, x,y,width,height, title, flag=0)
    OpenWindow_(window, x,y,width,height, title, flag)
  EndMacro
  
  ;events::SetCallback(@EventHandler())
  ;/// first
  OpenWindow(1, 200, 100, 320, 320, "window_1", #PB_Window_SystemMenu)
  CanvasGadget(0, 240, 10, 60, 60, #PB_Canvas_Keyboard);|#PB_Canvas_DrawFocus)
  CanvasGadget(1, 10, 10, 200, 200, #PB_Canvas_Keyboard);|#PB_Canvas_DrawFocus)
  CanvasGadget(11, 110, 110, 200, 200, #PB_Canvas_Keyboard);|#PB_Canvas_DrawFocus)
  ButtonGadget(100, 60,240,60,60,"")
  g1=CanvasGadget(-1,0,0,0,0,#PB_Canvas_Keyboard)
  g2=CanvasGadget(-1,0,0,0,0,#PB_Canvas_Keyboard)
  SplitterGadget(111,10,240,60,60, g1,g2)
  
  ; If Set((111),#PB_Cursor_UpDown)
  ;   Debug "updown"           
  ; EndIf       
  
  If cursor::Set((100),#PB_Cursor_Hand)
    Debug "setCursorHand"           
  EndIf       
  
  If cursor::Set((g1),#PB_Cursor_IBeam)
    Debug "setCursorIBeam"           
  EndIf       
  
  If cursor::Set((g2),#PB_Cursor_IBeam)
    Debug "setCursorIBeam"           
  EndIf       
  
  If LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/world.png") = 0
    MessageRequester("Error",
                     "Loading of image World.png failed!",
                     #PB_MessageRequester_Error)
    End
  EndIf
  ;If cursor::Set((0), ImageID(0))
  If cursor::Set((0), cursor::#PB_Cursor_drop)
    Debug "setCursorImage"           
  EndIf       
  
  If cursor::Set((1),#PB_Cursor_Hand)
    Debug "setCursorHand - " ;+CocoaMessage(0, 0, "NSCursor currentCursor")
  EndIf       
  
  If cursor::Set((11),#PB_Cursor_Cross)
    Debug "setCursorCross"           
  EndIf       
  
  
  ;/// second
  OpenWindow(2, 450, 200, 220, 220, "window_2", #PB_Window_SystemMenu|#PB_Window_SizeGadget)
  Define g1=StringGadget(-1,0,0,0,0,"StringGadget")
  Define g2=HyperLinkGadget(-1,0,0,0,0,"HyperLinkGadget", 0)
  SplitterGadget(2, 10, 10, 200, 200, g1,g2)
  BindEvent(#PB_Event_SizeWindow, @Resize_2(), 2)
  
  ;   If cursor::Set((g1),#PB_Cursor_IBeam)
  ;     Debug "setCursorIBeam"           
  ;   EndIf       
  ;   
  ;   If cursor::Set((g2),#PB_Cursor_Hand)
  ;     Debug "setCursorHand"           
  ;   EndIf       
  ;   
  ;   If cursor::Set((2),#PB_Cursor_UpDown)
  ;     Debug "setCursorHand"           
  ;   EndIf       
  
  
  ;/// third
  OpenWindow(3, 450+50, 200+50, 220, 220, "window_3", #PB_Window_SystemMenu|#PB_Window_SizeGadget)
  g1=CanvasGadget(-1,0,0,0,0,#PB_Canvas_Keyboard)
  g2=StringGadget(-1,0,0,0,0,"StringGadget")
  SplitterGadget(3,10, 10, 200, 200, g1,g2)
  BindEvent(#PB_Event_SizeWindow, @Resize_3(), 3)
  
  If cursor::Set((g1),#PB_Cursor_IBeam)
    Debug "setCursorIBeam"           
  EndIf       
  
  ;   If cursor::Set((g2),#PB_Cursor_IBeam)
  ;     Debug "setCursorIBeam"           
  ;   EndIf       
  
  
  ;Debug "currentCursor - "+CocoaMessage(0, 0, "NSCursor currentCursor") ; CocoaMessage(0, 0, "NSCursor systemCursor") +" "+ 
  ;;events::SetCallback(@EventHandler())
  
  OpenWindow(#PB_Any, 550, 300, 328, 328, "window_4", #PB_Window_SystemMenu)
  Define Canvas_0 = CanvasGadget(#PB_Any, 8, 8, 86, 86)
  ;;Canvas_1 = CanvasGadget(#PB_Any, 8, 72, 56, 56)
  Define left = CanvasGadget(#PB_Any, 8, 136, 24, 56)
  Define left2 = CanvasGadget(#PB_Any, 8+24+8, 136, 24, 56)
  ;;Canvas_3 = CanvasGadget(#PB_Any, 8, 200, 56, 56)
  Define Canvas_32 = CanvasGadget(#PB_Any, 8, 264, 56, 56)
  
  ;   Canvas_4 = CanvasGadget(#PB_Any, 72, 8, 56, 56)
  Define lt = CanvasGadget(#PB_Any, 72, 72, 56, 56)
  Define left3 = CanvasGadget(#PB_Any, 72, 136, 56, 56)
  Define lb = CanvasGadget(#PB_Any, 72, 200, 56, 56)
  ;   Canvas_72 = CanvasGadget(#PB_Any, 72, 264, 56, 56)
  
  Define up = CanvasGadget(#PB_Any, 136, 8, 56, 24)
  Define up2 = CanvasGadget(#PB_Any, 136, 8+24+8, 56, 24)
  Define up3 = CanvasGadget(#PB_Any, 136, 72, 56, 56)
  Define c = CanvasGadget(#PB_Any, 136, 136, 56, 56)
  Define down3 = CanvasGadget(#PB_Any, 136, 200, 56, 56)
  Define down = CanvasGadget(#PB_Any, 136, 264+8+24, 56, 24)
  Define down2 = CanvasGadget(#PB_Any, 136, 264, 56, 24)
  
  ;   Canvas_12 = CanvasGadget(#PB_Any, 200, 8, 56, 56)
  Define rt = CanvasGadget(#PB_Any, 200, 72, 56, 56)
  Define right3 = CanvasGadget(#PB_Any, 200, 136, 56, 56)
  Define rb = CanvasGadget(#PB_Any, 200, 200, 56, 56)
  ;   Canvas_152 = CanvasGadget(#PB_Any, 200, 264, 56, 56)
  
  Define Canvas_16 = CanvasGadget(#PB_Any, 264, 8, 56, 56)
  ;;Canvas_17 = CanvasGadget(#PB_Any, 264, 72, 56, 56)
  Define right = CanvasGadget(#PB_Any, 264+8+24, 136, 24, 56)
  Define right2 = CanvasGadget(#PB_Any, 264, 136, 24, 56)
  ;;Canvas_19 = CanvasGadget(#PB_Any, 264, 200, 56, 56)
  Define Canvas_192 = CanvasGadget(#PB_Any, 264, 264, 56, 56)
  
;   Cursor::Set((Canvas_0), Cursor::#PB_Cursor_Invisible ) 
;   Cursor::Set((left2), Cursor::#PB_Cursor_LeftRight ) 
;   Cursor::Set((right2), Cursor::#PB_Cursor_LeftRight ) 
;   
;   ;   Cursor::Set((lt), Cursor::#PB_Cursor_LeftUpRightDown ) 
; ;   Cursor::Set((rb), Cursor::#PB_Cursor_LeftUpRightDown ) 
;   Cursor::Set((lt), Cursor::#PB_Cursor_LeftUp ) 
;   Cursor::Set((rb), Cursor::#PB_Cursor_RightDown ) 
;   Cursor::Set((up2), Cursor::#PB_Cursor_UpDown ) 
;   Cursor::Set((down2), Cursor::#PB_Cursor_UpDown ) 
; ;   Cursor::Set((rt), Cursor::#PB_Cursor_LeftDownRightUp ) 
; ;   Cursor::Set((lb), Cursor::#PB_Cursor_LeftDownRightUp ) 
;   Cursor::Set((rt), Cursor::#PB_Cursor_RightUp ) 
;   Cursor::Set((lb), Cursor::#PB_Cursor_LeftDown ) 
; 
;   Cursor::Set((left), Cursor::#PB_Cursor_Left ) 
;   Cursor::Set((up), Cursor::#PB_Cursor_Up ) 
;   Cursor::Set((right), Cursor::#PB_Cursor_Right ) 
;   Cursor::Set((down), Cursor::#PB_Cursor_Down ) 
;   Cursor::Set((left3), Cursor::#PB_Cursor_Left ) 
;   Cursor::Set((up3), Cursor::#PB_Cursor_Up ) 
;   Cursor::Set((Right3), Cursor::#PB_Cursor_Right ) 
;   Cursor::Set((down3), Cursor::#PB_Cursor_Down ) 
;   Cursor::Set((c), Cursor::#PB_Cursor_Arrows ) 
;   Cursor::Set((Canvas_16), Cursor::#PB_Cursor_Cross ) 
;   Cursor::Set((Canvas_32), Cursor::#PB_Cursor_Denied ) 
;   Cursor::Set((Canvas_192), Cursor::#PB_Cursor_Drop ) 
  
  Cursor::Set((left2), Cursor::#PB_Cursor_LeftRight ) 
  Cursor::Set((right2), Cursor::#PB_Cursor_LeftRight ) 
;   Cursor::Set((lt), Cursor::#PB_Cursor_LeftUpRightDown ) 
;   Cursor::Set((rb), Cursor::#PB_Cursor_LeftUpRightDown ) 
  Cursor::Set((lt), Cursor::#PB_Cursor_LeftUp ) 
  Cursor::Set((rb), Cursor::#PB_Cursor_RightDown ) 
  Cursor::Set((up2), Cursor::#PB_Cursor_UpDown ) 
  Cursor::Set((down2), Cursor::#PB_Cursor_UpDown ) 
;   Cursor::Set((rt), Cursor::#PB_Cursor_LeftDownRightUp ) 
;   Cursor::Set((lb), Cursor::#PB_Cursor_LeftDownRightUp ) 
  Cursor::Set((rt), Cursor::#PB_Cursor_RightUp ) 
  Cursor::Set((lb), Cursor::#PB_Cursor_LeftDown ) 
  Cursor::Set((left), Cursor::#PB_Cursor_Left ) 
  Cursor::Set((up), Cursor::#PB_Cursor_Up ) 
  Cursor::Set((right), Cursor::#PB_Cursor_Right ) 
  Cursor::Set((down), Cursor::#PB_Cursor_Down ) 
  Cursor::Set((c), Cursor::#PB_Cursor_Arrows ) 
  Cursor::Set((Canvas_16), Cursor::#PB_Cursor_Cross ) 
  Cursor::Set((Canvas_0), Cursor::#PB_Cursor_Invisible ) 
  Cursor::Set((Canvas_32), Cursor::#PB_Cursor_Denied ) 
  Cursor::Set((Canvas_192), Cursor::#PB_Cursor_Busy ) 
  
  ;-
  Macro DrawUp(x, y, size, bcolor, fcolor)
    Line(x+7, y, 2, 1, fcolor)                                                                                         ; 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    Plot(x+6, y+1, fcolor ) : Line(x+7, y+1, 2, 1, bcolor) : Plot(x+9, y+1, fcolor )                                   ; 0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0
    Plot(x+5, y+2, fcolor ) : Line(x+6, y+2, 4, 1, bcolor) : Plot(x+10, y+2, fcolor )                                  ; 0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0
    Plot(x+4, y+3, fcolor ) : Line(x+5, y+3, 6, 1, bcolor) : Plot(x+11, y+3, fcolor )                                  ; 0,0,0,0,0,1,1,1,1,1,1,0,0,0,0,0
    Line(x+4, y+4, 3, 1, fcolor) : Line(x+7, y+4, 2, 1, bcolor) : Line(x+size/2+1, y+4, 3 , 1, fcolor)                 ; 0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0
    Plot(x+size/2-2, y+5, fcolor ) : Line(x+7, y+5, 2, 1, bcolor) : Plot(x+size/2+1, y+5, fcolor )                     ; 0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0
  EndMacro
  Macro DrawDown(x, y, size, bcolor, fcolor)
    Plot(x+size/2-2, y+4, fcolor ) : Line(x+7, y+4, 2, 1, bcolor) : Plot(x+size/2+1, y+4, fcolor )                     ; 0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0
    Line(x+4, y+5, 3, 1, fcolor) : Line(x+7, y+5, 2, 1, bcolor) : Line(x+size/2+1, y+5, 3, 1, fcolor)                  ; 0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0
    Plot(x+4, y+6, fcolor ) : Line(x+5, y+6, 6, 1, bcolor) : Plot(x+11, y+6, fcolor )                                  ; 0,0,0,0,0,1,1,1,1,1,1,0,0,0,0,0
    Plot(x+5, y+7, fcolor ) : Line(x+6, y+7, 4, 1, bcolor) : Plot(x+10, y+7, fcolor )                                  ; 0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0
    Plot(x+6, y+8, fcolor ) : Line(x+7, y+8, 2, 1, bcolor) : Plot(x+9, y+8, fcolor )                                   ; 0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0
    Line(x+7, y+9, 2, 1, fcolor)                                                                                       ; 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
  EndMacro
  Macro DrawLeft(x, y, width, bcolor, fcolor)
    Line(x, y+7, 1, 2, fcolor)                                                                                          ; 0,0,0,0,0,0,0,0,0
    Plot(x+1, y+6, fcolor ) : Line(x+1, y+7, 1, 2, bcolor) : Plot(x+1, y+9, fcolor )                                    ; 1,0,0,0,0,0,0,0,0
    Plot(x+2, y+5, fcolor ) : Line(x+2, y+6, 1, 4, bcolor) : Plot(x+2, y+10, fcolor )                                   ; 1,0,0,0,0,0,0,0,0
    Plot(x+3, y+4, fcolor ) : Line(x+3, y+5, 1, 6, bcolor) : Plot(x+3, y+11, fcolor )                                   ; 1,0,0,0,0,0,0,0,0
    Line(x+4, y+4, 1, 3, fcolor) : Line(x+4, y+7, 1, 2, bcolor) : Line(x+4, y+width/2+1, 1, 3, fcolor)                  ; 1,0,0,0,0,0,0,0,0
    Plot(x+5, y+width/2-2, fcolor ) : Line(x+5, y+7, 1, 2, bcolor) : Plot(x+5, y+width/2+1, fcolor )                    ; 1,0,0,0,0,1,0,0,0
  EndMacro  
  Macro DrawRight(x, y, width, bcolor, fcolor)
    Plot(x+4, y+width/2-2, fcolor ) : Line(x+4, y+7, 1, 2, bcolor) : Plot(x+4, y+width/2+1, fcolor )                    ; 0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0
    Line(x+5, y+4, 1, 3, fcolor) : Line(x+5, y+7, 1, 2, bcolor) : Line(x+5, y+width/2+1, 1, 3, fcolor)                  ; 0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0
    Plot(x+6, y+4, fcolor ) : Line(x+6, y+5, 1, 6, bcolor) : Plot(x+6, y+11, fcolor )                                   ; 0,0,0,0,0,1,1,1,1,1,1,0,0,0,0,0
    Plot(x+7, y+5, fcolor ) : Line(x+7, y+6, 1, 4, bcolor) : Plot(x+7, y+10, fcolor )                                   ; 0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0
    Plot(x+8, y+6, fcolor ) : Line(x+8, y+7, 1, 2, bcolor) : Plot(x+8, y+9, fcolor )                                    ; 0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0
    Line(x+9, y+7, 1, 2, fcolor)                                                                                        ; 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
  EndMacro
  
  Macro DrawCursor2(x, y, width, height, bcolor, fcolor)
    DrawUp(x, y, size, bcolor, fcolor)
    DrawDown(x, y+height-2, size, bcolor, fcolor)
    
    LineXY(x,y+1,x+5,y+6,bcolor)
    LineXY(x+1,y+1,x+5,y+5,bcolor)
    ;     Plot(x+1, y+2, bcolor )
    ;     Plot(x+2, y+1, bcolor )
    ;     
    ;     Plot(x+2, y+3, bcolor )
    ;     Plot(x+3, y+2, bcolor )
    ;     
    ;     Plot(x+3, y+4, bcolor )
    ;     Plot(x+4, y+3, bcolor )
    ;     
    ;     Plot(x+4, y+5, bcolor )
    ;     Plot(x+5, y+4, bcolor )
  EndMacro  
  Macro DrawCursor6(x, y, width, bcolor, fcolor)
    ;     Plot(x+4, y+width/2-2, fcolor ) : Line(x+4, y+7, 1, 2, bcolor) : Plot(x+4, y+width/2+1, fcolor )                    ; 0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0
    ;     Line(x+5, y+3, 1, width/3-1, fcolor) : Line(x+5, y+7, 1, 2, bcolor) : Line(x+5, y+width/2+1, 1, width/3-1, fcolor)  ; 0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0
    ;     Plot(x+6, y+4, fcolor ) : Line(x+6, y+5, 1, 6, bcolor) : Plot(x+6, y+11, fcolor )                                   ; 0,0,0,0,0,1,1,1,1,1,1,0,0,0,0,0
    ;     Plot(x+7, y+5, fcolor ) : Line(x+7, y+6, 1, 4, bcolor) : Plot(x+7, y+10, fcolor )                                   ; 0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0
    ;     Plot(x+8, y+6, fcolor ) : Line(x+8, y+7, 1, 2, bcolor) : Plot(x+8, y+9, fcolor )                                    ; 0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0
    ;     Line(x+9, y+7, 1, 2, fcolor)                                                                                        ; 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
  EndMacro
  
  Macro DrawCursorSplitterV(x, y, width, height, bcolor, fcolor)
    DrawUp(x, y, width, bcolor, fcolor)
    DrawCursorSplitterUp(x,y,width, bcolor, fcolor )
    DrawCursorSplitterDown(x,y+height-1,width, bcolor, fcolor )
    DrawDown(x, y+height-1, width, bcolor, fcolor)
  EndMacro
  Macro DrawCursorSplitterH(x, y, height, width, bcolor, fcolor)
    DrawLeft(x, y, width, bcolor, fcolor)
    DrawCursorSplitterLeft(x,y,width, bcolor, fcolor )
    DrawCursorSplitterRight(x,y+height-1,width, bcolor, fcolor )
    DrawRight(x, y+height-1, width, bcolor, fcolor)
  EndMacro
  
  Macro DrawCursorUp(x, y, width, bcolor, fcolor)
    DrawUp(x, y, width, bcolor, fcolor)
    Plot(x+width/2-2, y+6, fcolor ) : Line(x+7, y+6, 2, 1, bcolor) : Plot(x+width/2+1, y+6, fcolor )                   ; 0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0
    Plot(x+width/2-2, y+7, fcolor ) : Line(x+7, y+7, 2, 1, bcolor) : Plot(x+width/2+1, y+7, fcolor )                   ; 0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0
  EndMacro
  Macro DrawCursorDown(x, y, width, bcolor, fcolor)
    Plot(x+width/2-2, y+2, fcolor ) : Line(x+7, y+2, 2, 1, bcolor) : Plot(x+width/2+1, y+2, fcolor )                   ; 0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0
    Plot(x+width/2-2, y+3, fcolor ) : Line(x+7, y+3, 2, 1, bcolor) : Plot(x+width/2+1, y+3, fcolor )                   ; 0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0
    DrawDown(x, y, width, bcolor, fcolor)
  EndMacro
  Macro DrawCursorLeft(x, y, width, bcolor, fcolor)
    DrawLeft(x, y, width, bcolor, fcolor)
    Plot(x+6, y+width/2-2, fcolor ) : Line(x+6, y+7, 1, 2, bcolor) : Plot(x+6, y+width/2+1, fcolor )                    ; 1,0,0,0,0,1,0,0,0
    Plot(x+7, y+width/2-2, fcolor ) : Line(x+7, y+7, 1, 2, bcolor) : Plot(x+7, y+width/2+1, fcolor )                    ; 1,0,0,0,0,1,0,0,0
  EndMacro  
  Macro DrawCursorRight(x, y, width, bcolor, fcolor)
    Plot(x+2, y+width/2-2, fcolor ) : Line(x+2, y+7, 1, 2, bcolor) : Plot(x+2, y+width/2+1, fcolor )                    ; 0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0
    Plot(x+3, y+width/2-2, fcolor ) : Line(x+3, y+7, 1, 2, bcolor) : Plot(x+3, y+width/2+1, fcolor )                    ; 0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0
    DrawRight(x, y, width, bcolor, fcolor)
  EndMacro
  
  Macro DrawCursorSplitterUp(x, y, width, bcolor, fcolor)
    Line(x, y+6, width/2-1 , 1, fcolor) : Line(x+7, y+6, 2, 1, bcolor) : Line(x+width/2+1, y+6, width/2-1, 1, fcolor)   ; 0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0
    Plot(x, y+7, fcolor ) : Line(x+1, y+7, width-2, 1, bcolor) : Plot(x+width-1, y+7, fcolor )                          ; 0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0
  EndMacro
  Macro DrawCursorSplitterDown(x, y, width, bcolor, fcolor)
    Plot(x, y+2, fcolor ) : Line(x+1, y+2, width-2, 1, bcolor) : Plot(x+width-1, y+2, fcolor )                          ; 0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0
    Line(x, y+3, width/2-1, 1, fcolor) : Line(x+7, y+3, 2, 1, bcolor) : Line(x+width/2+1, y+3, width/2-1 , 1, fcolor)   ; 0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0
  EndMacro
  Macro DrawCursorSplitterLeft(x, y, width, bcolor, fcolor)
    ;Debug width
    DrawLeft(x, y, width, bcolor, fcolor)
    Line(x+6, y , 1, width/2-1, fcolor) : Line(x+6, y+7, 1, 2, bcolor) : Line(x+6, y+width/2+1, 1, width/2-1, fcolor)   ; 1,0,0,0,0,1,1,0,0
    Plot(x+7, y, fcolor ) : Line(x+7, y+1, 1, width-2, bcolor) : Plot(x+7, y+width-1, fcolor )                          ; 1,1,1,1,1,1,1,1,0
  EndMacro  
  Macro DrawCursorSplitterRight(x, y, width, bcolor, fcolor)
    Plot(x+2, y, fcolor ) : Line(x+2, y+1, 1, width-2, bcolor) : Plot(x+2, y+width-1, fcolor )                          ; 0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0
    Line(x+3, y, 1, width/2-1, fcolor) : Line(x+3, y+7, 1, 2, bcolor) : Line(x+3, y+width/2+1, 1, width/2-1, fcolor)    ; 0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0
    DrawRight(x, y, width, bcolor, fcolor)
  EndMacro
  
  Define x,y
  Define fcolor = $FFFFFF
  Define bcolor = $000000
  Define width = 16
  Define height = 7
  
  If StartDrawing(CanvasOutput(lt))
    Box(0,0,OutputWidth(),OutputHeight(), $A9B7B6)
    x = (OutputWidth()-width)/2
    y = (OutputHeight()-width)/2
    ; 
    LineXY(x+3,y+2,x+13,y+12,bcolor)
    LineXY(x+2,y+2,x+13,y+13,bcolor)
    LineXY(x+2,y+3,x+12,y+13,bcolor)
    
    Plot(x+12,y+10,bcolor)
    Plot(x+10,y+12,bcolor)
    Plot(x+5,y+3,bcolor)
    Plot(x+3,y+5,bcolor)
    
    Line(x+2,y+4,1,3,bcolor)
    Line(x+4,y+2,3,1,bcolor)
    Line(x+9,y+13,3,1,bcolor)
    Line(x+13,y+9,1,3,bcolor)
    
    ;
    LineXY(x+6,y+4,x+11,y+9,fcolor)
    LineXY(x+4,y+6,x+9,y+11,fcolor)
    
    LineXY(x+2,y+7,x+3,y+6,fcolor)
    LineXY(x+7,y+2,x+6,y+3,fcolor)
    LineXY(x+8,y+13,x+9,y+12,fcolor)
    LineXY(x+13,y+8,x+12,y+9,fcolor)
    
    Line(x+1,y+2,1,6,fcolor)
    Line(x+14,y+8,1,6,fcolor)
    Line(x+2,y+1,6,1,fcolor)
    Line(x+8,y+14,6,1,fcolor)
    
    StopDrawing()
  EndIf
  
  If StartDrawing(CanvasOutput(rb))
    Box(0,0,OutputWidth(),OutputHeight(), $A9B7B6)
    x = (OutputWidth()-width)/2
    y = (OutputHeight()-width)/2
    ; 
    LineXY(x+3,y+2,x+13,y+12,bcolor)
    LineXY(x+2,y+2,x+13,y+13,bcolor)
    LineXY(x+2,y+3,x+12,y+13,bcolor)
    
    Plot(x+12,y+10,bcolor)
    Plot(x+10,y+12,bcolor)
    Plot(x+5,y+3,bcolor)
    Plot(x+3,y+5,bcolor)
    
    Line(x+2,y+4,1,3,bcolor)
    Line(x+4,y+2,3,1,bcolor)
    Line(x+9,y+13,3,1,bcolor)
    Line(x+13,y+9,1,3,bcolor)
    
    ;
    LineXY(x+6,y+4,x+11,y+9,fcolor)
    LineXY(x+4,y+6,x+9,y+11,fcolor)
    
    LineXY(x+2,y+7,x+3,y+6,fcolor)
    LineXY(x+7,y+2,x+6,y+3,fcolor)
    LineXY(x+8,y+13,x+9,y+12,fcolor)
    LineXY(x+13,y+8,x+12,y+9,fcolor)
    
    Line(x+1,y+2,1,6,fcolor)
    Line(x+14,y+8,1,6,fcolor)
    Line(x+2,y+1,6,1,fcolor)
    Line(x+8,y+14,6,1,fcolor)
    
    StopDrawing()
  EndIf
  
  If StartDrawing(CanvasOutput(rt))
    Box(0,0,OutputWidth(),OutputHeight(), $A9B7B6)
    x = (OutputWidth()-width)/2
    y = (OutputHeight()-width)/2
    ; 
    LineXY(x+2,y+12,x+12,y+2,bcolor)
    LineXY(x+2,y+13,x+13,y+2,bcolor)
    LineXY(x+3,y+13,x+13,y+3,bcolor)
    
    Plot(x+3,y+10,bcolor)
    Plot(x+10,y+3,bcolor)
    Plot(x+5,y+12,bcolor)
    Plot(x+12,y+5,bcolor)
    
    Line(x+2,y+9,1,3,bcolor)
    Line(x+9,y+2,3,1,bcolor)
    Line(x+4,y+13,3,1,bcolor)
    Line(x+13,y+4,1,3,bcolor)
    
    ;
    LineXY(x+4,y+9,x+9,y+4,fcolor)
    LineXY(x+6,y+11,x+11,y+6,fcolor)
    
    LineXY(x+2,y+8,x+3,y+9,fcolor)
    LineXY(x+8,y+2,x+9,y+3,fcolor)
    LineXY(x+6,y+12,x+7,y+13,fcolor)
    LineXY(x+12,y+6,x+13,y+7,fcolor)
    
    Line(x+1,y+8,1,6,fcolor)
    Line(x+8,y+1,6,1,fcolor)
    Line(x+2,y+14,6,1,fcolor)
    Line(x+14,y+2,1,6,fcolor)
    
    StopDrawing()
  EndIf
  
  If StartDrawing(CanvasOutput(lb))
    Box(0,0,OutputWidth(),OutputHeight(), $A9B7B6)
    x = (OutputWidth()-width)/2
    y = (OutputHeight()-width)/2
    ; 
    LineXY(x+2,y+12,x+12,y+2,bcolor)
    LineXY(x+2,y+13,x+13,y+2,bcolor)
    LineXY(x+3,y+13,x+13,y+3,bcolor)
    
    Plot(x+3,y+10,bcolor)
    Plot(x+10,y+3,bcolor)
    Plot(x+5,y+12,bcolor)
    Plot(x+12,y+5,bcolor)
    
    Line(x+2,y+9,1,3,bcolor)
    Line(x+9,y+2,3,1,bcolor)
    Line(x+4,y+13,3,1,bcolor)
    Line(x+13,y+4,1,3,bcolor)
    
    ;
    LineXY(x+4,y+9,x+9,y+4,fcolor)
    LineXY(x+6,y+11,x+11,y+6,fcolor)
    
    LineXY(x+2,y+8,x+3,y+9,fcolor)
    LineXY(x+8,y+2,x+9,y+3,fcolor)
    LineXY(x+6,y+12,x+7,y+13,fcolor)
    LineXY(x+12,y+6,x+13,y+7,fcolor)
    
    Line(x+1,y+8,1,6,fcolor)
    Line(x+8,y+1,6,1,fcolor)
    Line(x+2,y+14,6,1,fcolor)
    Line(x+14,y+2,1,6,fcolor)
    
    StopDrawing()
  EndIf
  
  ; splitter
  If StartDrawing(CanvasOutput(left))
    Box(0,0,OutputWidth(),OutputHeight(), $A9B7B6)
    x = (OutputWidth()-height)/2
    y = (OutputHeight()-width)/2
    
    ; left                                                 
    DrawCursorSplitterLeft(x,y,width, bcolor, fcolor )
    Plot(x+8, y, fcolor ) : Line(x+8, y+1, 1, width-2, bcolor) : Plot(x+8, y+width-1, fcolor )                        ; 0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0
    Line(x + 9, y, 1, width, fcolor)                                                                                  ; 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    StopDrawing()
  EndIf
  If StartDrawing(CanvasOutput(left2))
    Box(0,0,OutputWidth(),OutputHeight(), $A9B7B6)
    x = (OutputWidth()-(height*2))/2
    y = (OutputHeight()-width)/2
    
    ; left2                                                 
    DrawCursorSplitterLeft(x,y,width, bcolor, fcolor )
    DrawCursorSplitterRight(x+height-1,y,width, bcolor, fcolor )
    StopDrawing()
  EndIf
  If StartDrawing(CanvasOutput(right2))
    Box(0,0,OutputWidth(),OutputHeight(), $A9B7B6)
    x = (OutputWidth()-(height*2))/2
    y = (OutputHeight()-width)/2
    
    ; right2                                                 
    DrawCursorSplitterLeft(x,y,width, bcolor, fcolor )
    DrawCursorSplitterRight(x+height-1,y,width, bcolor, fcolor )
    StopDrawing()
  EndIf
  If StartDrawing(CanvasOutput(right))
    Box(0,0,OutputWidth(),OutputHeight(), $A9B7B6)
    x = (OutputWidth()-height)/2
    y = (OutputHeight()-width)/2
    
    ; right                                                 
    Line(x, y, 1, width, fcolor)                                                                                         ; 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    Plot(x+1, y, fcolor ) : Line(x+1, y+1, 1, width-2, bcolor) : Plot(x+1, y+width-1, fcolor )                           ; 0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0
    DrawCursorSplitterRight(x,y,width, bcolor, fcolor )
    StopDrawing()
  EndIf
  
  If StartDrawing(CanvasOutput(c))
    Box(0,0,OutputWidth(),OutputHeight(), $A9B7B6)
    x = (OutputWidth()-width)/2
    y = (OutputHeight()-(height*2))/2
    
    ; down2                                                 
    Box(x+6,y+5,4,4, fcolor)
    DrawCursorUp(x,y-2,width, bcolor, fcolor )
    DrawCursorDown(x,y+height-1,width, bcolor, fcolor )
    
    DrawCursorLeft(x-1,y-1,width, bcolor, fcolor )
    DrawCursorRight(x+7,y-1,width, bcolor, fcolor )
    Box(x+7,y+6,2,2, bcolor)
    
    StopDrawing()
  EndIf
  
  If StartDrawing(CanvasOutput(left3))
    Box(0,0,OutputWidth(),OutputHeight(), $A9B7B6)
    x = (OutputWidth()-(height*2))/2
    y = (OutputHeight()-width)/2
    ; ver-size
    DrawCursorLeft(x-1,y,width, bcolor, fcolor )
    DrawCursorRight(x+height-2,y,width, bcolor, fcolor )
    StopDrawing()
  EndIf
  
  If StartDrawing(CanvasOutput(up3))
    Box(0,0,OutputWidth(),OutputHeight(), $A9B7B6)
    x = (OutputWidth()-width)/2
    y = (OutputHeight()-(height*2))/2
    ; hor-size
    DrawCursorUp(x,y-1,width, bcolor, fcolor )
    DrawCursorDown(x,y+height-2,width, bcolor, fcolor )
    StopDrawing()
  EndIf
  
  If StartDrawing(CanvasOutput(right3))
    Box(0,0,OutputWidth(),OutputHeight(), $A9B7B6)
    ;     x = (OutputWidth()-width)/2
    ;     y = (OutputHeight()-(height*2))/2
    ;     
    ;     ; down2                                                 
    ;     ;Box(x+6,y+5,4,4, fcolor)
    
    x = (OutputWidth()-(height*2))/2
    y = (OutputHeight()-width)/2
    
    DrawCursorLeft(x-1,y,width, bcolor, fcolor )
    DrawCursorRight(x+height-2,y,width, bcolor, fcolor )
    ;Box(x+6,y+7,2,2, bcolor)
    
    StopDrawing()
  EndIf
  
  If StartDrawing(CanvasOutput(down3))
    Box(0,0,OutputWidth(),OutputHeight(), $A9B7B6)
    x = (OutputWidth()-width)/2
    y = (OutputHeight()-(height*2))/2
    
    ; down2                                                 
    ; Box(x+6,y+5,4,4, fcolor)
    DrawCursorUp(x,y-1,width, bcolor, fcolor )
    DrawCursorDown(x,y+height-2,width, bcolor, fcolor )
    
    ;     x = (OutputWidth()-(height*2))/2
    ;     y = (OutputHeight()-width)/2
    ;     ;Box(x+6,y+7,2,2, bcolor)
    
    StopDrawing()
  EndIf
  
  If StartDrawing(CanvasOutput(up))
    Box(0,0,OutputWidth(),OutputHeight(), $A9B7B6)
    x = (OutputWidth()-width)/2
    y = (OutputHeight()-height)/2
    
    ; up                                                 
    DrawUp(x, y, width, bcolor, fcolor)
    DrawCursorSplitterUp(x,y,width, bcolor, fcolor )
    Plot(x, y+8, fcolor ) : Line(x+1, y+8, width-2, 1, bcolor) : Plot(x+width-1, y+8, fcolor )                          ; 0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0
    Line(x, y + 9, width , 1, fcolor)                                                                                   ; 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    StopDrawing()
  EndIf
  
  If StartDrawing(CanvasOutput(up2))
    Box(0,0,OutputWidth(),OutputHeight(), $A9B7B6)
    x = (OutputWidth()-width)/2
    y = (OutputHeight()-(height*2))/2
    
    ; down2                                                 
    DrawCursorSplitterV(x,y,width,height, bcolor, fcolor )
    StopDrawing()
  EndIf
  
  If StartDrawing(CanvasOutput(down2))
    Box(0,0,OutputWidth(),OutputHeight(), $A9B7B6)
    x = (OutputWidth()-width)/2
    y = (OutputHeight()-(height*2))/2
    
    ; down2                                                 
    DrawCursorSplitterV(x,y,width,height, bcolor, fcolor )
    StopDrawing()
  EndIf
  
  If StartDrawing(CanvasOutput(down))
    Box(0,0,OutputWidth(),OutputHeight(), $A9B7B6)
    x = (OutputWidth()-width)/2
    y = (OutputHeight()-height)/2
    
    ; down                                                 
    Line(x, y, width, 1, fcolor)                                                                                         ; 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    Plot(x, y+1, fcolor ) : Line(x+1, y+1, width-2, 1, bcolor) : Plot(x+width-1, y+1, fcolor )                           ; 0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0
    DrawCursorSplitterDown(x,y,width, bcolor, fcolor )
    DrawDown(x, y, width, bcolor, fcolor)
    StopDrawing()
  EndIf
  
  
  If StartDrawing(CanvasOutput(Canvas_16))
    Box(0,0,OutputWidth(),OutputHeight(), $A9B7B6)
    ;       img = CocoaMessage(0, 0, "NSCursor resizeUpCursor")
    ;       ;DrawImage(img, 0,0)
    width = 13
    Line(OutputWidth()/2-1, OutputHeight()/2-width/2, 1, width, fcolor)
    Line(OutputWidth()/2+1, OutputHeight()/2-width/2, 1, width, fcolor)
    
    Line(OutputWidth()/2-width/2, OutputHeight()/2-1, width, 1, fcolor)
    Line(OutputWidth()/2-width/2, OutputHeight()/2+1, width, 1, fcolor)
    
    Line(OutputWidth()/2, OutputHeight()/2-width/2, 1, width, bcolor)
    Line(OutputWidth()/2-width/2, OutputHeight()/2, width, 1, bcolor)
    StopDrawing()
  EndIf
  
  Define EnteredGadget =- 1
  Define LeavedGadget =- 1 
  Define buttons = 0
  
  Repeat 
    event = WaitWindowEvent()
    EnteredGadget = ID::Gadget(Mouse::Gadget(Mouse::Window()))
    
    If LeavedGadget <> EnteredGadget And buttons = 0
      ; Debug  CocoaMessage(0, CocoaMessage(0,0,"NSApplication sharedApplication"), "NSEvent")
      
      If LeavedGadget >= 0
        ; Debug GetGadgetAttribute(LeavedGadget, #PB_Canvas_Buttons)
        EventHandler(LeavedGadget, #PB_EventType_MouseLeave, 0)
        ;Cursor::Change(GadgetID(LeavedGadget), 0 )
        ; PostEvent(#PB_Event_Gadget, EventWindow(), LeavedGadget, #PB_EventType_CursorChange, 0)
      EndIf
      
      If EnteredGadget >= 0
        ; Debug GetGadgetAttribute(EnteredGadget, #PB_Canvas_Buttons)
        EventHandler(EnteredGadget, #PB_EventType_MouseEnter, 1)
        ;Cursor::Change(GadgetID(EnteredGadget), 1 )
        ; PostEvent(#PB_Event_Gadget, EventWindow(), EnteredGadget, #PB_EventType_CursorChange, 1)
      EndIf
      LeavedGadget = EnteredGadget
    EndIf
    
    If event = #PB_Event_Gadget
      Select EventType()
        Case #PB_EventType_CursorChange
          ; Cursor::Change(GadgetID(EventGadget()), EventData() )
          
        Case #PB_EventType_LeftButtonDown
          buttons = 1
          
        Case #PB_EventType_LeftButtonUp
          buttons = 0
      EndSelect
    EndIf
    
  Until event = #PB_Event_CloseWindow
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = 2+j+-Ht-----------
; EnableXP