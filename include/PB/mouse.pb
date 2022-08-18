CompilerIf #PB_Compiler_IsMainFile 
  ;   XIncludeFile "ID.pbi"
  ;   XIncludeFile "Get.pbi"
  DeclareModule Get
    Declare.s ClassName( handle.i )
  EndDeclareModule
  Module Get
    Procedure.s ClassName( handle.i )
      Protected Result
      CocoaMessage( @Result, CocoaMessage( 0, handle, "className" ), "UTF8String" )
      If Result
        ProcedureReturn PeekS( Result, -1, #PB_UTF8 )
      EndIf
    EndProcedure
  EndModule
  ;////
  DeclareModule ID
    Declare.i Window( WindowID.i )
    Declare.i Gadget( GadgetID.i )
    Declare.i IsWindowID( handle.i )
    Declare.i GetWindowID( handle.i )
  EndDeclareModule
  Module ID
    ;   XIncludeFile "../import.pbi"
    Import ""
      PB_Window_GetID(hWnd) 
    EndImport
    
    Procedure.s ClassName( handle.i )
      Protected Result
      CocoaMessage( @Result, CocoaMessage( 0, handle, "className" ), "UTF8String" )
      
      If Result
        ProcedureReturn PeekS( Result, - 1, #PB_UTF8 )
      EndIf
    EndProcedure
    
    Procedure.i GetWindowID( handle.i ) ; Return the handle of the parent window from the handle
      ProcedureReturn CocoaMessage( 0, handle, "window" )
    EndProcedure
    
    Procedure.i IsWindowID( handle.i )
      If ClassName( handle ) = "PBWindow"
        ProcedureReturn 1
      EndIf
    EndProcedure
    
    Procedure.i Window( WindowID.i ) ; Return the id of the window from the window handle
      ProcedureReturn PB_Window_GetID( WindowID )
    EndProcedure
    
    Procedure.i Gadget( GadgetID.i )  ; Return the id of the gadget from the gadget handle
      ProcedureReturn CocoaMessage(0, GadgetID, "tag")
    EndProcedure
  EndModule
  
  ; CompilerIf #PB_Compiler_IsMainFile 
  ;   EnableExplicit
  ;   Global eventID
  ;   
  ;   OpenWindow(1, 0, 0, 200, 100, "window", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  ;   ButtonGadget(1, 10, 10, 180,80, "button" ) 
  ;   
  ;   Debug "gadget - "+GadgetID(1) +" >> "+ ID::Gadget(GadgetID(1))
  ;   Debug "window - "+WindowID(1) +" >> "+ ID::Window(WindowID(1))
  ;   
  ;   Repeat
  ;     eventID = WaitWindowEvent( )
  ;   Until eventID = #PB_Event_CloseWindow
  ; CompilerEndIf
CompilerEndIf

DeclareModule Mouse
  Declare.i Window( )
  Declare.i Gadget( WindowID )
EndDeclareModule

Module Mouse
  Procedure Window( )
    Protected.i NSApp, NSWindow, WindowNumber, Point.CGPoint
    
    ; get-WindowNumber
    CocoaMessage(@Point, 0, "NSEvent mouseLocation")
    WindowNumber = CocoaMessage(0, 0, "NSWindow windowNumberAtPoint:@", @Point, "belowWindowWithWindowNumber:", 0)
    
    ; get-NSWindow
    NSApp = CocoaMessage(0, 0, "NSApplication sharedApplication")
    NSWindow = CocoaMessage(0, NSApp, "windowWithWindowNumber:", WindowNumber)
    
    ProcedureReturn NSWindow
  EndProcedure
  
  Macro GetCocoa( objectCocoa, funcCocoa, paramCocoa )
    CocoaMessage(0, objectCocoa, funcCocoa+":@", @paramCocoa)
  EndMacro
  
  Procedure Gadget( WindowID )
    Protected.i handle, superview, ContentView, Point.CGPoint
    
    If  WindowID 
      ContentView = CocoaMessage(0,  WindowID , "contentView")
      CocoaMessage(@Point,  WindowID , "mouseLocationOutsideOfEventStream")
      
      ;       ;func isMousePoint(_ point: NSPoint, in rect: NSRect ) -> Bool
      ;       Debug GetCocoa( ContentView, "isMousePoint", Point) 
      
      ; func hitTest(_ point: NSPoint) -> NSView? ; Point.NSPoint
      handle = CocoaMessage(0, ContentView, "hitTest:@", @Point) ; hitTest(_:) 
                                                                 ;handle = GetCocoa( ContentView, "hitTest", Point) 
      
      If handle
        Select Get::ClassName( handle )
          Case "NSStepper" 
            ;handle = CocoaMessage(0, handle, "superclass") ; NSControl
            
            ; handle = CocoaMessage( 0, handle, "nextResponder" ) ; PB_SpinView
            ;handle = CocoaMessage( 0, handle, "superview" ) ; PB_SpinView
            
            ;handle = CocoaMessage(0, handle, "superclass") ; NSView
            
            ;;handle = CocoaMessage(0, handle, "contentView") ; 
            ;Debug  Get::ClassName( CocoaMessage(0, handle, "subviews") );
            ;Debug  Get::ClassName( CocoaMessage(0, handle, "opaqueAncestor") );
            ;Debug  Get::ClassName( CocoaMessage(0, handle, "enclosingScrollView") );
            ;;Debug  Get::ClassName( CocoaMessage(0, handle, "superclass") );
            ;;handle = CocoaMessage(0, handle, "opaqueAncestor") ; 
            ;; handle = CocoaMessage( 0, handle, "superview" ) ; PB_SpinView
            
            ; handle = CocoaMessage( 0, handle, "NSTextView" ) ; PB_SpinView
            ; handle = CocoaMessage( 0, handle, "NSTextField" ) ; PB_SpinView
            Debug  Get::ClassName( handle ) 
            
          Case "NSTableHeaderView" 
            handle = CocoaMessage(0, handle, "tableView") ; PB_NSTableView
            
          Case "NSScroller"                                 ;
                                                            ; PBScrollView
            handle = CocoaMessage( 0, handle, "superview" ) ; NSScrollView
            
            Select Get::ClassName( handle ) 
              Case "WebDynamicScrollBarsView"
                handle = CocoaMessage( 0, handle, "superview" ) ; WebFrameView
                handle = CocoaMessage( 0, handle, "superview" ) ; PB_WebView
                
              Case "PBTreeScrollView"
                handle = CocoaMessage(0, handle, "documentView")
                
              Case "NSScrollView"
                superview = CocoaMessage( 0, handle, "superview" )
                If Get::ClassName( superview ) = "PBScintillaView"
                  handle = superview ; PBScintillaView
                Else
                  handle = CocoaMessage(0, handle, "documentView")
                EndIf
                
            EndSelect
            
          Case "_NSRulerContentView", "SCIContentView" 
            handle = CocoaMessage( 0, handle, "superview" ) ; NSClipView
            handle = CocoaMessage( 0, handle, "superview" ) ; NSScrollView
            handle = CocoaMessage( 0, handle, "superview" ) ; PBScintillaView
            
          Case "NSView" 
            handle = CocoaMessage( 0, handle, "superview" ) ; PB_NSBox
            
          Case "NSTextField", "NSButton"
            handle = CocoaMessage( 0, handle, "superview" ) ; PB_DateView
            
          Case "WebHTMLView" 
            handle = CocoaMessage( 0, handle, "superview" ) ; WebClipView
            handle = CocoaMessage( 0, handle, "superview" ) ; WebDynamicScrollBarsView
            handle = CocoaMessage( 0, handle, "superview" ) ; WebFrameView
            handle = CocoaMessage( 0, handle, "superview" ) ; PB_WebView
            
          Case "PB_NSFlippedView"                           ;
                                                            ; container
            handle = CocoaMessage( 0, handle, "superview" ) ; NSClipView
                                                            ; scrollarea
            If Get::ClassName( handle ) = "NSClipView"
              handle = CocoaMessage( 0, handle, "superview" ) ; PBScrollView
            EndIf
            ;           Default
            ;             Debug "-"  
            ;             Debug  Get::ClassName( handle ) ; PB_NSTextField
            ;             Debug "-"
        EndSelect
      EndIf
    EndIf
    
    ProcedureReturn handle
  EndProcedure
EndModule

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile 
  EnableExplicit
  UsePNGImageDecoder( )
  
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
    SetWindowColor(ID::Window(UseGadgetList(0)), $83BFEC)
    
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
    
    InitScintilla( )
    ScintillaGadget(#PB_GadgetType_Scintilla, 830, 5, 160,95,0 )
    ShortcutGadget(#PB_GadgetType_Shortcut, 830, 105, 160,95 ,-1)
    CanvasGadget(#PB_GadgetType_Canvas, 830, 205, 160,95 )
    CanvasGadget(#PB_GadgetType_Canvas+1, 830, 305, 160,95, #PB_Canvas_Container )
    
    Define eventID,  WindowID , gadgetID
    Repeat
      eventID = WaitWindowEvent( )
      WindowID = Mouse::Window( )
      gadgetID = Mouse::Gadget( WindowID )
      
      If gadgetID
        If ID::Gadget( gadgetID ) =- 1
          Debug "window - ("+ ID::Window( WindowID ) +") "+ WindowID ;+" "+ GetClassName( WindowID )
        Else
          Debug "gadget - ("+ ID::Gadget( gadgetID ) +") "+ gadgetID ;+" "+ GetClassName( gadgetID )
        EndIf
      EndIf
      
      Select eventID 
        Case #PB_Event_Gadget
          If EventGadget( ) = #PB_GadgetType_ScrollBar
            SetGadgetState( #PB_GadgetType_ProgressBar, GetGadgetState( #PB_GadgetType_ScrollBar ) )
          EndIf
      EndSelect
    Until eventID = #PB_Event_CloseWindow
  EndIf   
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = ------
; EnableXP