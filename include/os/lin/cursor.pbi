;\\
XIncludeFile "../cursors.pbi"

Module Cursor 
  ; https://www.manpagez.com/html/gdk/gdk-3.12.0/gdk3-Cursors.php#GdkCursorType
  ;--- LINUX:
  ;   GDK_X_CURSOR 		  = 0,
  ;   GDK_ARROW 		  = 2,
  ;   GDK_BASED_ARROW_DOWN    = 4,
  ;   GDK_BASED_ARROW_UP 	  = 6,
  ;   GDK_BOAT 		  = 8,
  ;   GDK_BOGOSITY 		  = 10,
  ;   GDK_BOTTOM_LEFT_CORNER  = 12,
  ;   GDK_BOTTOM_RIGHT_CORNER = 14,
  ;   GDK_BOTTOM_SIDE 	  = 16,
  ;   GDK_BOTTOM_TEE 	  = 18,
  ;   GDK_BOX_SPIRAL 	  = 20,
  ;   GDK_CENTER_PTR 	  = 22,
  ;   GDK_CIRCLE 		  = 24,
  ;   GDK_CLOCK	 	  = 26,
  ;   GDK_COFFEE_MUG 	  = 28,
  ;   GDK_CROSS 		  = 30,
  ;   GDK_CROSS_REVERSE 	  = 32,
  ;   GDK_CROSSHAIR 	  = 34,
  ;   GDK_DIAMOND_CROSS 	  = 36,
  ;   GDK_DOT 		  = 38,
  ;   GDK_DOTBOX 		  = 40,
  ;   GDK_DOUBLE_ARROW 	  = 42,
  ;   GDK_DRAFT_LARGE 	  = 44,
  ;   GDK_DRAFT_SMALL 	  = 46,
  ;   GDK_DRAPED_BOX 	  = 48,
  ;   GDK_EXCHANGE 		  = 50,
  ;   GDK_FLEUR 		  = 52,
  ;   GDK_GOBBLER 		  = 54,
  ;   GDK_GUMBY 		  = 56,
  ;   GDK_HAND1 		  = 58,
  ;   GDK_HAND2 		  = 60,
  ;   GDK_HEART 		  = 62,
  ;   GDK_ICON 		  = 64,
  ;   GDK_IRON_CROSS 	  = 66,
  ;   GDK_LEFT_PTR 		  = 68,
  ;   GDK_LEFT_SIDE 	  = 70,
  ;   GDK_LEFT_TEE 		  = 72,
  ;   GDK_LEFTBUTTON 	  = 74,
  ;   GDK_LL_ANGLE 		  = 76,
  ;   GDK_LR_ANGLE 	 	  = 78,
  ;   GDK_MAN 		  = 80,
  ;   GDK_MIDDLEBUTTON 	  = 82,
  ;   GDK_MOUSE 		  = 84,
  ;   GDK_PENCIL 		  = 86,
  ;   GDK_PIRATE 		  = 88,
  ;   GDK_PLUS 		  = 90,
  ;   GDK_QUESTION_ARROW 	  = 92,
  ;   GDK_RIGHT_PTR 	  = 94,
  ;   GDK_RIGHT_SIDE 	  = 96,
  ;   GDK_RIGHT_TEE 	  = 98,
  ;   GDK_RIGHTBUTTON 	  = 100,
  ;   GDK_RTL_LOGO 		  = 102,
  ;   GDK_SAILBOAT 		  = 104,
  ;   GDK_SB_DOWN_ARROW 	  = 106,
  ;   GDK_SB_H_DOUBLE_ARROW   = 108,
  ;   GDK_SB_LEFT_ARROW 	  = 110,
  ;   GDK_SB_RIGHT_ARROW 	  = 112,
  ;   GDK_SB_UP_ARROW 	  = 114,
  ;   GDK_SB_V_DOUBLE_ARROW   = 116,
  ;   GDK_SHUTTLE 		  = 118,
  ;   GDK_SIZING 		  = 120,
  ;   GDK_SPIDER		  = 122,
  ;   GDK_SPRAYCAN 		  = 124,
  ;   GDK_STAR 		  = 126,
  ;   GDK_TARGET 		  = 128,
  ;   GDK_TCROSS 		  = 130,
  ;   GDK_TOP_LEFT_ARROW 	  = 132,
  ;   GDK_TOP_LEFT_CORNER 	  = 134,
  ;   GDK_TOP_RIGHT_CORNER 	  = 136,
  ;   GDK_TOP_SIDE 		  = 138,
  ;   GDK_TOP_TEE 		  = 140,
  ;   GDK_TREK 		  = 142,
  ;   GDK_UL_ANGLE 		  = 144,
  ;   GDK_UMBRELLA 		  = 146,
  ;   GDK_UR_ANGLE 		  = 148,
  ;   GDK_WATCH 		  = 150,
  ;   GDK_XTERM 		  = 152
  #GDK_BLANK_CURSOR = -2 ; пустой курсор
                         ;   GDK_CURSOR_IS_PIXMAP = -1
  
  ; https://www.manpagez.com/html/gdk/gdk-3.12.0/gdk3-Cursors.php 
  ;   GdkКурсор  *	gdk_cursor_new  ()
  ;   GdkКурсор  *	gdk_cursor_new_from_pixbuf  ()
  ;   GdkКурсор  *	gdk_cursor_new_from_surface  ()
  ;   GdkКурсор  *	gdk_cursor_new_from_name  ()
  ;   GdkКурсор  *	gdk_cursor_new_for_display  ()
  ;   GdkDisplay  *	gdk_cursor_get_display  ()
  ;   GdkPixbuf  *	gdk_cursor_get_image  ()
  ;   cairo_surface_t  *	gdk_cursor_get_surface  ()
  ;   GdkCursorType	gdk_cursor_get_cursor_type  ()
  ;   GdkКурсор  *	gdk_cursor_ref  ()
  ;                	gdk_cursor_unref  ()
  
  ; gdk_cursor_get_image( GdkCursor *cursor);  Возвращает GdkPixbuf с изображением, используемым для отображения курсора.
  
  ImportC ""
    gtk_widget_get_window(*widget.GtkWidget)
    gdk_cursor_get_cursor_type(*cursor.GDKCursor)
    gdk_window_get_cursor(*widget.GtkWidget)
    g_object_set_data(*Widget.GtkWidget, strData.p-utf8, *userdata)
  EndImport
  ;     ImportC "" ; -gtk"
  ;     g_object_set_data_(*Widget.GtkWidget, strData.p-utf8, *userdata) As "g_object_set_data"
  ;     g_object_get_data_(*Widget.GtkWidget, strData.p-utf8) As "g_object_get_data"
  ;   EndImport
  
  
  Global NewMap images.i()
  
  ;-\\
  Procedure Image( type.i = 0 )
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
    ;     ; Используйте g_object_unref()
    ;     ProcedureReturn gdk_cursor_unref_(hCursor)
    EndIf
  EndProcedure
  
  Procedure   isHiden()
    ProcedureReturn 0;Bool( gdk_cursor_get_cursor_type(gdk_window_get_cursor( gdk_display_get_default_() )) = #GDK_BLANK_CURSOR )
  EndProcedure
  
  Procedure   Hide(state.b)
    ;     ; Чтобы сделать курсор невидимым, используйте GDK_BLANK_CURSOR.
    ;     If state
    ;       gdk_cursor_new_for_display_(gdk_display_get_default_(),gdk_cursor_new_(#GDK_BLANK_CURSOR))
    ;       ;gdk_cursor_new_from_name("none")
    ;     Else
    ;       gdk_cursor_new_for_display_(gdk_display_get_default_(),gdk_cursor_new_(#GDK_ARROW))
    ;     EndIf
  EndProcedure
  
  Procedure.i Create(ImageID.i, x.l = 0, y.l = 0)
     ProcedureReturn gdk_cursor_new_from_pixbuf_( gdk_display_get_default_(), ImageID, x, y)
  EndProcedure
  
  Procedure Change( GadgetID.i, state.b )
    Protected *cursor._s_cursor = g_object_get_data_(GadgetID, "__cursor") ; GetGadgetData(EnteredGadget())
    If *cursor And 
       *cursor\hcursor  
      
      ; reset 
      If state = 0 
        gdk_window_set_cursor_( gtk_widget_get_window(*cursor\windowID), gdk_cursor_new_(#GDK_ARROW))
      EndIf
      
      ; set
      If state = 1 
        gdk_window_set_cursor_( gtk_widget_get_window(*cursor\windowID), *cursor\hcursor)
      EndIf
      
      CompilerIf #PB_Compiler_IsMainFile
        Debug "changeCursor"
      CompilerEndIf
    EndIf
  EndProcedure
  
  Procedure Set(Gadget.i, icursor.i)
    If IsGadget( Gadget )
      Protected *cursor._s_cursor
      Protected GadgetID = GadgetID(Gadget)
      CompilerIf #PB_Compiler_IsMainFile
        Debug "setCursor"
      CompilerEndIf
      
      *cursor = g_object_get_data_(GadgetID, "__cursor")
      
      If Not *cursor
        *cursor = AllocateStructure(_s_cursor)
        *cursor\windowID = ID::GetWindowID(GadgetID)
        g_object_set_data(GadgetID, "__cursor", *cursor) 
      EndIf
      
      If *cursor\icursor <> icursor
        *cursor\icursor = icursor
        
        If icursor >= 0 And icursor <= 255
          Select icursor
            Case #PB_Cursor_Default   : *cursor\hcursor = gdk_cursor_new_(#GDK_LEFT_PTR) ; GDK_LEFT_PTR ; GDK_RIGHT_PTR ; GDK_CENTER_PTR
            Case #PB_Cursor_Cross     : *cursor\hcursor = gdk_cursor_new_(#GDK_CROSS) ; GDK_TCROSS ; GDK_CROSS ; GDK_CROSSHAIR ; GDK_PLUS
            Case #PB_Cursor_IBeam     : *cursor\hcursor = gdk_cursor_new_(#GDK_XTERM)
            Case #PB_Cursor_Hand      : *cursor\hcursor = gdk_cursor_new_(#GDK_HAND2) ; GDK_HAND1 ; GDK_HAND2
            Case #PB_Cursor_Busy      : *cursor\hcursor = gdk_cursor_new_(#GDK_WATCH)
            Case #PB_Cursor_Denied    : *cursor\hcursor = gdk_cursor_new_(#GDK_X_CURSOR)
            Case #PB_Cursor_Arrows    : *cursor\hcursor = gdk_cursor_new_(#GDK_FLEUR)
            
            ;;Case #PB_Cursor_Invisible : *cursor\hcursor = gdk_cursor_new_for_display_(gdk_display_get_default_(), #GDK_BLANK_CURSOR)
            Case #PB_Cursor_Invisible : *cursor\hcursor = gdk_cursor_new_(#GDK_BLANK_CURSOR); GDK_UR_ANGLE ; GDK_TOP_RIGHT_CORNER ; GDK_LL_ANGLE ; GDK_BOTTOM_LEFT_CORNER
              Debug 888
              
            Case #PB_Cursor_Left      : *cursor\hcursor = gdk_cursor_new_(#GDK_LEFT_SIDE) ; GDK_LEFT_TEE ; GDK_LEFT_SIDE ; #GDK_SB_LEFT_ARROW
            Case #PB_Cursor_Right     : *cursor\hcursor = gdk_cursor_new_(#GDK_RIGHT_SIDE) ; GDK_RIGHT_TEE ; GDK_RIGHT_SIDE ; #GDK_SB_RIGHT_ARROW
            Case #PB_Cursor_LeftRight : *cursor\hcursor = gdk_cursor_new_(#GDK_SB_H_DOUBLE_ARROW);GDK_SB_H_DOUBLE_ARROW ; GDK_SB_LEFT_ARROW ; GDK_SB_RIGHT_ARROW
              
            Case #PB_Cursor_Up        : *cursor\hcursor = gdk_cursor_new_(#GDK_TOP_SIDE) ; GDK_TOP_TEE ; GDK_TOP_SIDE
            Case #PB_Cursor_Down      : *cursor\hcursor = gdk_cursor_new_(#GDK_BOTTOM_SIDE) ; GDK_BOTTOM_TEE ; GDK_BOTTOM_SIDE
            ;Case #PB_Cursor_UpDown    : *cursor\hcursor = gdk_cursor_new_(#GDK_SB_V_DOUBLE_ARROW); GDK_SB_V_DOUBLE_ARROW ; GDK_SB_UP_ARROW ; GDK_SB_DOWN_ARROW
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
              
            Case #PB_Cursor_LeftUpRightDown  : *cursor\hcursor = gdk_cursor_new_(#GDK_TOP_LEFT_CORNER); GDK_UL_ANGLE ; GDK_TOP_LEFT_CORNER ; GDK_LR_ANGLE ; GDK_BOTTOM_RIGHT_CORNER
            Case #PB_Cursor_LeftDownRightUp  : *cursor\hcursor = gdk_cursor_new_(#GDK_TOP_RIGHT_CORNER)
              
            Case #PB_Cursor_LeftUp          : *cursor\hcursor = gdk_cursor_new_for_display_(gdk_display_get_default_(), #GDK_TOP_LEFT_CORNER);gdk_cursor_new_(#GDK_TOP_LEFT_CORNER)
            Case #PB_Cursor_RightUp         : *cursor\hcursor = gdk_cursor_new_for_display_(gdk_display_get_default_(), #GDK_TOP_RIGHT_CORNER)
            Case #PB_Cursor_LeftDown       : *cursor\hcursor = gdk_cursor_new_for_display_(gdk_display_get_default_(), #GDK_BOTTOM_LEFT_CORNER)
            Case #PB_Cursor_RightDown      : *cursor\hcursor = gdk_cursor_new_for_display_(gdk_display_get_default_(), #GDK_BOTTOM_RIGHT_CORNER)
               
            Case #PB_Cursor_Drag : *cursor\hcursor = New( icursor )
            Case #PB_Cursor_Drop : *cursor\hcursor = New( icursor )
              
            Case #PB_Cursor_Grab      : *cursor\hcursor = gdk_cursor_new_(#GDK_ARROW)
            Case #PB_Cursor_Grabbing  : *cursor\hcursor = gdk_cursor_new_(#GDK_ARROW)
         EndSelect 
        Else
          *cursor\hcursor = icursor 
        EndIf
      EndIf
      
      If *cursor\hcursor And GadgetID = mouse::Gadget(*cursor\windowID)
        Change( GadgetID, 1 )
        ProcedureReturn #True
      EndIf
    EndIf
  EndProcedure
  
  Procedure   Get()
    ;    ; gdk_cursor_get_cursor_type_(GdkCursor *cursor) ; Возвращает тип курсора для этого курсора.
         Protected result.i, currentSystemCursor
    ;     
    ;     ;Debug ""+ CocoaMessage(@currentSystemCursor, 0, "NSCursor currentSystemCursor") +" "+ currentSystemCursor+" "+ CocoaMessage(0, 0, "NSCursor currentCursor")
    ;     
    ;     If isHiden() ;  GetGadgetAttribute(EventGadget(), #PB_Canvas_CustomCursor) ; 
    ;       result = #PB_Cursor_Invisible
    ;     Else
    ;       Select gdk_window_get_cursor( gdk_display_get_default_() )
    ;         Case gdk_cursor_new_(#GDK_LEFT_PTR) : result = #PB_Cursor_Default
    ;         Case gdk_cursor_new_(#GDK_XTERM) : result = #PB_Cursor_IBeam
    ;           
    ;         Case gdk_cursor_new_(#GDK_ARROW) : result = #PB_Cursor_Drop
    ;         Case gdk_cursor_new_(#GDK_ARROW) : result = #PB_Cursor_Drag
    ;         Case gdk_cursor_new_(#GDK_X_CURSOR) : result = #PB_Cursor_Denied
    ;           
    ;         Case gdk_cursor_new_(#GDK_CROSS) : result = #PB_Cursor_Cross
    ;         Case gdk_cursor_new_(#GDK_HAND2) : result = #PB_Cursor_Hand
    ;         Case gdk_cursor_new_(#GDK_ARROW) : result = #PB_Cursor_Grab
    ;         Case gdk_cursor_new_(#GDK_ARROW) : result = #PB_Cursor_Grabbing
    ;           
    ;         Case gdk_cursor_new_(#GDK_FLEUR) : result = #PB_Cursor_Arrows
    ;         Case gdk_cursor_new_(#GDK_ARROW) : result = #PB_Cursor_Up
    ;         Case gdk_cursor_new_(#GDK_ARROW) : result = #PB_Cursor_Down
    ;         Case gdk_cursor_new_(#GDK_ARROW) : result = #PB_Cursor_UpDown
    ;           
    ;         Case gdk_cursor_new_(#GDK_ARROW) : result = #PB_Cursor_Left
    ;         Case gdk_cursor_new_(#GDK_ARROW) : result = #PB_Cursor_Right
    ;         Case gdk_cursor_new_(#GDK_ARROW) : result = #PB_Cursor_LeftRight
    ;       EndSelect 
    ;     EndIf
    ;     
    ProcedureReturn result
  EndProcedure
EndModule  
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = 0-w---
; EnableXP