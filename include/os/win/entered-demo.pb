EnableExplicit

Procedure IDWindow( handle.i ) ; Return the id of the window from the window handle
  Protected Window = GetProp_( handle, "PB_WindowID" ) - 1
  If IsWindow( Window ) And WindowID( Window ) = handle
    ProcedureReturn Window
  EndIf
  ProcedureReturn - 1
EndProcedure

Procedure IDGadget( handle.i )  ; Return the id of the gadget from the gadget handle
  Protected gadget = GetProp_( handle, "PB_ID" )
  If IsGadget( gadget ) And GadgetID( gadget ) = handle
    ProcedureReturn gadget
  EndIf
  ProcedureReturn - 1
EndProcedure

Procedure.s GetClassName( handle.i )
  Protected Class$ = Space( 16 )
  GetClassName_( handle, @Class$, Len( Class$ ) )
  ProcedureReturn Class$
EndProcedure

Procedure GetUMWindow( )
  Protected Cursorpos.q, handle
  GetCursorPos_( @Cursorpos )
  handle = WindowFromPoint_( Cursorpos )
  ProcedureReturn GetAncestor_( handle, #GA_ROOT )
EndProcedure

Procedure GetUMGadget( WindowID )
  Protected Cursorpos.q, handle, GadgetID
  GetCursorPos_( @Cursorpos )
  
  If WindowID
    GadgetID = WindowFromPoint_( Cursorpos )
    
    If IsGadget( IDGadget( GadgetID ) )
      handle = GadgetID
    Else
      ScreenToClient_( WindowID, @Cursorpos ) 
      handle = ChildWindowFromPoint_( WindowID, Cursorpos )
      
      ; spin-buttons
      If handle = GadgetID 
        If handle = WindowID
          ; in the window
          ProcedureReturn 0
        Else
          handle = GetWindow_( GadgetID, #GW_HWNDPREV )
        EndIf
      Else
        ; MDIGadget childrens
        ;           If IsWindow( IDWindow( GadgetID ) )
        ;             If handle = WindowID
        ;               ; in the window
        ;               ProcedureReturn 0
        ;             Else
        ;               ;;handle = GetParent_( handle )
        ;             EndIf
        ;           EndIf
      EndIf
    EndIf
    
    ProcedureReturn handle
  Else
    ProcedureReturn 0
  EndIf
EndProcedure

CompilerIf #PB_Compiler_OS = #PB_OS_Windows
  
  DeclareModule ID
  Declare.i Window( WindowID.i )
  Declare.i Gadget( GadgetID.i )
  Declare.i IsWindowID( handle.i )
  Declare.i GetWindowID( handle.i )
EndDeclareModule
Module ID
  Procedure.s ClassName( handle.i )
    Protected Class$ = Space( 16 )
    GetClassName_( handle, @Class$, Len( Class$ ) )
    ProcedureReturn Class$
  EndProcedure
  
  Procedure.i GetWindowID( handle.i ) ; Return the handle of the parent window from the handle
    ProcedureReturn GetAncestor_( handle, #GA_ROOT )
  EndProcedure
  
  Procedure.i IsWindowID( handle.i )
    If ClassName( handle ) = "PBWindow"
      ProcedureReturn 1
    EndIf
  EndProcedure
  
  Procedure.i Window( handle.i ) ; Return the id of the window from the window handle
    Protected Window = GetProp_( handle, "PB_WindowID" ) - 1
    If IsWindow( Window ) And WindowID( Window ) = handle
      ProcedureReturn Window
    EndIf
    ProcedureReturn - 1
  EndProcedure
  
  Procedure.i Gadget( handle.i )  ; Return the id of the gadget from the gadget handle
    Protected gadget = GetProp_( handle, "PB_ID" )
  If IsGadget( gadget ) And GadgetID( gadget ) = handle
    ProcedureReturn gadget
  EndIf
  ProcedureReturn - 1
EndProcedure
EndModule
DeclareModule Mouse
  Declare.i Window( )
  Declare.i Gadget( WindowID )
EndDeclareModule
Module Mouse
  Procedure Window( )
    Protected Cursorpos.q, handle
  GetCursorPos_( @Cursorpos )
  handle = WindowFromPoint_( Cursorpos )
  ProcedureReturn GetAncestor_( handle, #GA_ROOT )
EndProcedure
  
  Procedure Gadget( WindowID )
    Protected Cursorpos.q, handle, GadgetID
  GetCursorPos_( @Cursorpos )
  
  If WindowID
    GadgetID = WindowFromPoint_( Cursorpos )
    
    If IsGadget( ID::Gadget( GadgetID ) )
      handle = GadgetID
    Else
      ScreenToClient_( WindowID, @Cursorpos ) 
      handle = ChildWindowFromPoint_( WindowID, Cursorpos )
      
      ; spin-buttons
      If handle = GadgetID 
        If handle = WindowID
          ; in the window
          ProcedureReturn 0
        Else
          handle = GetWindow_( GadgetID, #GW_HWNDPREV )
        EndIf
      Else
        ; MDIGadget childrens
        ;           If IsWindow( IDWindow( GadgetID ) )
        ;             If handle = WindowID
        ;               ; in the window
        ;               ProcedureReturn 0
        ;             Else
        ;               ;;handle = GetParent_( handle )
        ;             EndIf
        ;           EndIf
      EndIf
    EndIf
    
    ProcedureReturn handle
  Else
    ProcedureReturn 0
  EndIf
EndProcedure
EndModule

Global OldProc
Declare Proc(hWnd, uMsg, wParam, lParam)

Procedure Proc(hWnd, uMsg, wParam, lParam)
  Protected gadget
  Protected result = 0
  
  Select uMsg
    Case #WM_MOUSEMOVE
      
;       gadget = mouse::gadget(hWnd)
;        Debug gadget
        result = CallWindowProc_(OldProc, hWnd, uMsg, wParam, lParam)
     
    Case #WM_SETCURSOR
        result = CallWindowProc_(OldProc, hWnd, uMsg, wParam, lParam)
     ;result = 0
   Default
      result = CallWindowProc_(OldProc, hWnd, uMsg, wParam, lParam)
  EndSelect
  
  ProcedureReturn result
EndProcedure

;-
  ; Для виндовс чтобы приклепить гаджеты на место
  ; надо вызывать процедуру в конце создания всех гаджетов
  ; 
  
Procedure GadgetsClipCallBack( GadgetID, lParam )
    ; https://www.purebasic.fr/english/viewtopic.php?t=64799
    ; https://www.purebasic.fr/english/viewtopic.php?f=5&t=63915#p475798
    ; https://www.purebasic.fr/english/viewtopic.php?t=63915&start=15
    If GadgetID
      Protected Gadget = ID::Gadget(GadgetID)
      
        If IsGadget(Gadget)
         ; OldProc = SetWindowLong_(GadgetID, #GWL_WNDPROC, @Proc())
        EndIf
        
      ;       If IsGadget( Gadget ) And GadgetID = GadgetID( Gadget )
      ;         Debug "Gadget "+ Gadget +"  -  "+ GadgetID
      ;       Else
      ;         Debug "- Gadget   -  "+ GadgetID
      ;       EndIf
      
      If GetWindowLongPtr_( GadgetID, #GWL_STYLE ) & #WS_CLIPSIBLINGS = #False 
        If IsGadget( Gadget ) 
          Select GadgetType( Gadget )
            Case #PB_GadgetType_ComboBox
              Protected Height = GadgetHeight( Gadget )
              
              ;             ; Из-за бага когда устанавливаешь фоновый рисунок (например точки на кантейнер)
              ;             Case #PB_GadgetType_Container 
              ;               SetGadgetColor( Gadget, #PB_Gadget_BackColor, GetSysColor_( #COLOR_BTNFACE ))
              ;               
              ;             ; Для панел гаджета темный фон убирать
              ;             Case #PB_GadgetType_Panel 
              ;               If Not IsGadget( Gadget ) And (GetWindowLongPtr_(GadgetID, #GWL_EXSTYLE) & #WS_EX_TRANSPARENT) = #False
              ;                 SetWindowLongPtr_(GadgetID, #GWL_EXSTYLE, GetWindowLongPtr_(GadgetID, #GWL_EXSTYLE) | #WS_EX_TRANSPARENT)
              ;               EndIf
              ;               ; SetClassLongPtr_(GadgetID, #GCL_HBRBACKGROUND, GetStockObject_(#NULL_BRUSH))
              
          EndSelect
        EndIf
        
        SetWindowLongPtr_( GadgetID, #GWL_STYLE, GetWindowLongPtr_( GadgetID, #GWL_STYLE ) | #WS_CLIPSIBLINGS | #WS_CLIPCHILDREN )
        
        If Height
          ResizeGadget( Gadget, #PB_Ignore, #PB_Ignore, #PB_Ignore, Height )
        EndIf
        
        SetWindowPos_( GadgetID, #GW_HWNDFIRST, 0,0,0,0, #SWP_NOMOVE|#SWP_NOSIZE )
       EndIf
      
    EndIf
    
    ProcedureReturn GadgetID
  EndProcedure
CompilerEndIf


Procedure ClipGadgets( WindowID )
  CompilerIf #PB_Compiler_OS = #PB_OS_Windows
    EnumChildWindows_( WindowID, @GadgetsClipCallBack(), 0 )
  CompilerEndIf
EndProcedure



;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile ;= 100
  EnableExplicit
  UsePNGImageDecoder()
  
  If Not LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/Background.bmp")
    End
  EndIf
  
  If Not LoadImage(1, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png")
    End
  EndIf
  
  Global x,y,i
  
  Procedure scrolled()
    
  EndProcedure
  
  
  If OpenWindow(#PB_Any, 0, 0, 995, 605, "", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    SetWindowColor(IDWindow(UseGadgetList(0)), $83BFEC)
    
    ButtonGadget(#PB_GadgetType_Button, 5, 5, 160,95, "Multiline Button_"+Str(#PB_GadgetType_Button)+" (longer text gets automatically multiline)", #PB_Button_MultiLine ) 
    StringGadget(#PB_GadgetType_String, 5, 105, 160,95, "String_"+Str(#PB_GadgetType_String)+" set"+#LF$+"multi"+#LF$+"line"+#LF$+"text")                                 
    TextGadget(#PB_GadgetType_Text, 5, 205, 160,95, "Text_"+Str(#PB_GadgetType_Text)+#LF$+"set"+#LF$+"multi"+#LF$+"line"+#LF$+"text", #PB_Text_Border)        
    CheckBoxGadget(#PB_GadgetType_CheckBox, 5, 305, 160,95, "CheckBox_"+Str(#PB_GadgetType_CheckBox), #PB_CheckBox_ThreeState) : SetGadgetState(#PB_GadgetType_CheckBox, #PB_Checkbox_Inbetween)
    OptionGadget(#PB_GadgetType_Option, 5, 405, 160,95, "Option_"+Str(#PB_GadgetType_Option) ) : SetGadgetState(#PB_GadgetType_Option, 1)                                                       
    ListViewGadget(#PB_GadgetType_ListView, 5, 505, 160,95) : AddGadgetItem(#PB_GadgetType_ListView, -1, "ListView_"+Str(#PB_GadgetType_ListView)) : For i=1 To 5 : AddGadgetItem(#PB_GadgetType_ListView, i, "item_"+Str(i)) : Next
    FrameGadget(#PB_GadgetType_Frame, 170, 5, 160,95, "Frame_"+Str(#PB_GadgetType_Frame) )
    ComboBoxGadget(#PB_GadgetType_ComboBox, 170, 105, 160,95) : AddGadgetItem(#PB_GadgetType_ComboBox, -1, "ComboBox_"+Str(#PB_GadgetType_ComboBox)) : For i=1 To 5 : AddGadgetItem(#PB_GadgetType_ComboBox, i, "item_"+Str(i)) : Next : SetGadgetState(#PB_GadgetType_ComboBox, 0) 
    ImageGadget(#PB_GadgetType_Image, 170, 205, 160,95, 0, #PB_Image_Border ) 
    HyperLinkGadget(#PB_GadgetType_HyperLink, 170, 305, 160,95,"HyperLink_"+Str(#PB_GadgetType_HyperLink), $00FF00, #PB_HyperLink_Underline ) 
    ContainerGadget(#PB_GadgetType_Container, 170, 405, 160,95, #PB_Container_Flat )
    OptionGadget(101, 10, 10, 110,20, "Container_"+Str(#PB_GadgetType_Container) )  : SetGadgetState(101, 1)  
    OptionGadget(102, 10, 40, 110,20, "Option_widget");, #pb_flag_flat)  
    CloseGadgetList()
    ListIconGadget(#PB_GadgetType_ListIcon,170, 505, 160,95,"ListIcon_"+Str(#PB_GadgetType_ListIcon),120 )                           
    
    IPAddressGadget(#PB_GadgetType_IPAddress, 335, 5, 160,95 ) : SetGadgetState(#PB_GadgetType_IPAddress, MakeIPAddress(1, 2, 3, 4))    
    ProgressBarGadget(#PB_GadgetType_ProgressBar, 335, 105, 160,95,0,100) : SetGadgetState(#PB_GadgetType_ProgressBar, 50)
    ScrollBarGadget(#PB_GadgetType_ScrollBar, 335, 205, 160,95,0,100,0) : SetGadgetState(#PB_GadgetType_ScrollBar, 40)
    ScrollAreaGadget(#PB_GadgetType_ScrollArea, 335, 305, 160,95,180,90,1, #PB_ScrollArea_Flat ) :  ButtonGadget(201, 0, 0, 150,20, "ScrollArea_"+Str(#PB_GadgetType_ScrollArea) ) :  ButtonGadget(202, 180-150, 90-20, 150,20, "Button_"+Str(202) ) : CloseGadgetList()
    TrackBarGadget(#PB_GadgetType_TrackBar, 335, 405, 160,95,0,21, #PB_TrackBar_Ticks) : SetGadgetState(#PB_GadgetType_TrackBar, 11)
    WebGadget(#PB_GadgetType_Web, 335, 505, 160,95,"https://www.purebasic.com" )
    
    ButtonImageGadget(#PB_GadgetType_ButtonImage, 500, 5, 160,95, ImageID(0), 1)
    CalendarGadget(#PB_GadgetType_Calendar, 500, 105, 160,95 )
    DateGadget(#PB_GadgetType_Date, 500, 205, 160,95 )
    EditorGadget(#PB_GadgetType_Editor, 500, 305, 160,95 ) : AddGadgetItem(#PB_GadgetType_Editor, -1, "set"+#LF$+"editor"+#LF$+"_"+Str(#PB_GadgetType_Editor) +#LF$+"add"+#LF$+"multi"+#LF$+"line"+#LF$+"text")  
    ExplorerListGadget(#PB_GadgetType_ExplorerList, 500, 405, 160,95,"" )
    ExplorerTreeGadget(#PB_GadgetType_ExplorerTree, 500, 505, 160,95,"" )
    
    ExplorerComboGadget(#PB_GadgetType_ExplorerCombo, 665, 5, 160,95,"" )
    SpinGadget(#PB_GadgetType_Spin, 665, 105, 160,95,20,100)
    
    TreeGadget(#PB_GadgetType_Tree, 665, 205, 160, 95 ) 
    AddGadgetItem(#PB_GadgetType_Tree, -1, "Tree_"+Str(#PB_GadgetType_Tree)) 
    For i=1 To 5 : AddGadgetItem(#PB_GadgetType_Tree, i, "item_"+Str(i)) : Next
    ButtonGadget(-1,665+10,205+5,50,35, "444444") 
    
    PanelGadget(#PB_GadgetType_Panel,665, 305, 160,95) 
    AddGadgetItem(#PB_GadgetType_Panel, -1, "Panel_"+Str(#PB_GadgetType_Panel)) 
    ButtonGadget(255, 0, 0, 90,20, "Button_255" ) 
    For i=1 To 5 : AddGadgetItem(#PB_GadgetType_Panel, i, "item_"+Str(i)) : ButtonGadget(-1,10,5,50,35, "butt_"+Str(i)) : Next 
    CloseGadgetList()
    
    OpenGadgetList(#PB_GadgetType_Panel, 1)
    ContainerGadget(-1,10,5,150,55, #PB_Container_Flat) 
    ContainerGadget(-1,10,5,150,55, #PB_Container_Flat) 
    ButtonGadget(-1,10,5,50,35, "butt_1") 
    CloseGadgetList()
    CloseGadgetList()
    CloseGadgetList()
    SetGadgetState( #PB_GadgetType_Panel, 4)
    
    SpinGadget(301, 0, 0, 100,20,0,10)
    SpinGadget(302, 0, 0, 100,20,0,10)                 
    SplitterGadget(#PB_GadgetType_Splitter, 665, 405, 160, 95, 301, 302)
    
    Define UseGadgetList = UseGadgetList(0)
    MDIGadget(#PB_GadgetType_MDI, 665, 505, 160,95, 1, 2);, #PB_MDI_AutoSize)
    Define *form = AddGadgetItem(#PB_GadgetType_MDI, -1, "form_0")
    ResizeWindow( *form, #PB_Ignore, 40, 120, 60)
    UseGadgetList( UseGadgetList ) ; go back to the main window gadgetlist
    
    InitScintilla()
    ScintillaGadget(#PB_GadgetType_Scintilla, 830, 5, 160,95,0 )
    ShortcutGadget(#PB_GadgetType_Shortcut, 830, 105, 160,95 ,-1)
    CanvasGadget(#PB_GadgetType_Canvas, 830, 205, 160,95 )
    CanvasGadget(#PB_GadgetType_Canvas+1, 830, 305, 160,95, #PB_Canvas_Container )
    
    ;
    ClipGadgets( UseGadgetList )
    
    Define eventID, windowID, gadgetID
    
 
    Repeat
      eventID = WaitWindowEvent()
      windowID = GetUMWindow( )
      gadgetID = GetUMGadget( windowID )
      
      If gadgetID
        If IDGadget( gadgetID ) =- 1
          Debug "window - ("+ IDWindow( windowID ) +") "+ windowID ;+" "+ GetClassName( windowID )
        Else
          Debug "gadget - ("+ IDGadget( gadgetID ) +") "+ gadgetID ;+" "+ GetClassName( gadgetID )
        EndIf
      EndIf
      
      Select eventID 
        Case #PB_Event_Gadget
          If EventGadget() = #PB_GadgetType_ScrollBar
            SetGadgetState(#PB_GadgetType_ProgressBar, GetGadgetState(#PB_GadgetType_ScrollBar))
          EndIf
      EndSelect
    Until eventID = #PB_Event_CloseWindow
  EndIf   
CompilerEndIf
; IDE Options = PureBasic 5.72 (Windows - x86)
; CursorPosition = 193
; FirstLine = 160
; Folding = -0-------
; EnableXP