CompilerIf Not Defined( constants, #PB_Module )
  DeclareModule constants
    Enumeration #PB_EventType_FirstCustomValue
      #PB_EventType_Drop
      #PB_EventType_CursorChange
      #PB_EventType_MouseWheelX
      #PB_EventType_MouseWheelY
    EndEnumeration
  EndDeclareModule
  Module constants
  EndModule
CompilerEndIf

CompilerSelect #PB_Compiler_OS 
  CompilerCase #PB_OS_MacOS   : IncludePath "mac"
  CompilerCase #PB_OS_Windows : IncludePath "win"
  CompilerCase #PB_OS_Linux   : IncludePath "lin"
CompilerEndSelect

XIncludeFile "id.pbi"
XIncludeFile "mouse.pbi"
; XIncludeFile "parent.pbi"

DeclareModule Cursor
  EnableExplicit
  UsePNGImageDecoder()
  
  Enumeration 
    #PB_Cursor_Default         ; = 0 
    #PB_Cursor_Cross           ; = 1 ; GDK_TCROSS ; GDK_CROSS ; GDK_CROSSHAIR ; GDK_PLUS
    #PB_Cursor_IBeam           ; = 2 ; GDK_XTERM
    #PB_Cursor_Hand            ; = 3  ; GDK_HAND1 ; GDK_HAND2
    #PB_Cursor_Busy            ; = 4  ; GDK_WATCH
    #PB_Cursor_Denied          ; = 5  ; GDK_X_CURSOR
    #PB_Cursor_Arrows          ; = 6  ; GDK_FLEUR
    
    #PB_Cursor_LeftRight       ; = 7  ;GDK_SB_H_DOUBLE_ARROW ; GDK_SB_LEFT_ARROW ; GDK_SB_RIGHT_ARROW
    #PB_Cursor_UpDown          ; = 8  ; GDK_SB_V_DOUBLE_ARROW ; GDK_SB_UP_ARROW ; GDK_SB_DOWN_ARROW
    #PB_Cursor_LeftUpRightDown ; = 9 ; GDK_UL_ANGLE ; GDK_TOP_LEFT_CORNER ; GDK_LR_ANGLE ; GDK_BOTTOM_RIGHT_CORNER
    #PB_Cursor_LeftDownRightUp ; = 10 ; GDK_UR_ANGLE ; GDK_TOP_RIGHT_CORNER ; GDK_LL_ANGLE ; GDK_BOTTOM_LEFT_CORNER
    
    #PB_Cursor_Invisible       ; = 11 ; GDK_BLANK_CURSOR
    
    #PB_Cursor_Left            ; GDK_LEFT_TEE ; GDK_LEFT_SIDE
    #PB_Cursor_Right           ; GDK_RIGHT_TEE ; GDK_RIGHT_SIDE
    #PB_Cursor_Up              ; GDK_TOP_TEE ; GDK_TOP_SIDE
    #PB_Cursor_Down            ; GDK_BOTTOM_TEE ; GDK_BOTTOM_SIDE
    
    #PB_Cursor_LeftUp
    #PB_Cursor_RightUp
    #PB_Cursor_LeftDown
    #PB_Cursor_RightDown
    
    #PB_Cursor_SeparatorLeft           
    #PB_Cursor_SeparatorLeftRight      
    #PB_Cursor_SeparatorRight           
    #PB_Cursor_SeparatorUp              
    #PB_Cursor_SeparatorUpDown        
    #PB_Cursor_SeparatorDown           
    
    #PB_Cursor_Grab            
    #PB_Cursor_Grabbing
    #PB_Cursor_Drag
    #PB_Cursor_Drop
    #PB_Cursor_VIBeam
  EndEnumeration
  
  Structure _s_cursor
    icursor.a
    *hcursor
    *windowID
  EndStructure
  
  Declare   isHiden( )
  Declare   Hide(state.b)
  Declare   Free(hCursor.i)
  Declare   Get( )
  Declare   Set(Gadget.i, cursor.i)
  Declare   Change(GadgetID.i, state.b )
  Declare.i Create(ImageID.i, x.l = 0, y.l = 0)
EndDeclareModule
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = -
; EnableXP