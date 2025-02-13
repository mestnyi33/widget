XIncludeFile "../widgets.pbi"
XIncludeFile "include/code_generate.pbi"

UseWidgets( )


Global NewMap FlagsString.s( )
Global NewMap EventsString.s( )
Global NewMap ImagePuchString.s( )
Global NewMap ClassString.s( )

Procedure.s GetClassString( Element )
   
   ProcedureReturn "" + GetClass( Element ) + "_" + CountType( Element, - 1 ) ; Trim( ClassString( Str( Element ) ), "|" )
   
EndProcedure

Procedure SetClassString( Element, Class$ )
   Protected ClassString
   If Not FindMapElement( ClassString( ), Str( Type( Element ) ) )
      AddMapElement( ClassString( ), Str( Type( Element ) ) )
   EndIf
   ClassString( ) = Str( Val( ClassString( ) ) + 1 )
   Class$ = Str( Val( ClassString( ) ) - 1 )
   
   If Not FindMapElement( ClassString( ), Str( Element ) )
      AddMapElement( ClassString( ), Str( Element ) )
   EndIf
   
   If Class$
      If Not FindString( ClassString( ), LCase( Class$ ), - 1, #PB_String_NoCase )
         ClassString( ) + "|" + Class$
      EndIf
   Else
      ClassString( ) = ""
   EndIf
   
EndProcedure

Procedure.s GetFlagsString( Element )
   
   ProcedureReturn Trim( FlagsString( Str( Element ) ), "|" )
   
EndProcedure

Procedure SetFlagsString( Element, Flags$ )
   
   If Not FindMapElement( FlagsString( ), Str( Element ) )
      AddMapElement( FlagsString( ), Str( Element ) )
   EndIf
   
   If Flags$
      If Not FindString( FlagsString( ), LCase( Flags$ ), - 1, #PB_String_NoCase )
         FlagsString( ) + "|" + Flags$
      EndIf
   Else
      FlagsString( ) = ""
   EndIf
   
EndProcedure

Procedure.s GetEventsString( Element )
   
   ProcedureReturn Trim( EventsString( Str( Element ) ), "|" )
   
EndProcedure

Procedure SetEventsString( Element, Events$ )
   
   If Not FindMapElement( EventsString( ), Str( Element ) )
      AddMapElement( EventsString( ), Str( Element ) )
   EndIf
   
   If Events$
      If Not FindString( EventsString( ), LCase( Events$ ), - 1, #PB_String_NoCase )
         EventsString( ) + "|" + Events$
      EndIf
   Else
      EventsString( ) = ""
   EndIf
   
EndProcedure

;- 
Procedure.s GeneratePBCode( *parent._s_WIDGET )
   Protected Type
   Protected Count
   Protected Image
   Protected Parent
   Protected Element
   Protected ParentName$, Name$, Code$, FormWindow$, FormGadget$, Gadgets$, Windows$, Events$, Functions$
   Static JPEGPlugin$, JPEG2000Plugin$, PNGPlugin$, TGAPlugin$, TIFFPlugin$
   Protected *mainWindow._s_WIDGET
   
   ; is element
   If IsChildrens( *parent )
      Code$ + "EnableExplicit" + #CRLF$ + #CRLF$
      
      If StartEnum( *parent, 0 )
         Image = GetImage( Element )
         
         ;UseIMAGEDecoder
         If IsImage( Image )
            Select ImageFormat( Image )
               Case #PB_ImagePlugin_JPEG
                  If JPEGPlugin$ <> "UseJPEGImageDecoder( )"
                     JPEGPlugin$ = "UseJPEGImageDecoder( )"
                     Code$ + "UseJPEGImageDecoder( )" + #CRLF$
                  EndIf
               Case #PB_ImagePlugin_JPEG2000
                  If JPEG2000Plugin$ <> "UseJPEG2000ImageDecoder( )"
                     JPEG2000Plugin$ = "UseJPEG2000ImageDecoder( )"
                     Code$ + "UseJPEG2000ImageDecoder( )" + #CRLF$
                  EndIf
               Case #PB_ImagePlugin_PNG
                  If PNGPlugin$ <> "UsePNGImageDecoder( )"
                     PNGPlugin$ = "UsePNGImageDecoder( )"
                     Code$ + "UsePNGImageDecoder( )" + #CRLF$
                  EndIf
               Case #PB_ImagePlugin_TGA
                  If TGAPlugin$ <> "UseTGAImageDecoder( )"
                     TGAPlugin$ = "UseTGAImageDecoder( )"
                     Code$ + "UseTGAImageDecoder( )" + #CRLF$
                  EndIf
               Case #PB_ImagePlugin_TIFF
                  If TIFFPlugin$ <> "UseTIFFImageDecoder( )"
                     TIFFPlugin$ = "UseTIFFImageDecoder( )"
                     Code$ + "UseTIFFImageDecoder( )" + #CRLF$
                  EndIf
               Case #PB_ImagePlugin_BMP
                  
               Case #PB_ImagePlugin_ICON
                  
            EndSelect
            
            Code$ + "LoadImage( " + Image + ", " + #DQUOTE$ + ImagePuchString( Str( Image ) ) + #DQUOTE$ + " )" + #CRLF$
         EndIf
         
         StopEnum( )
      EndIf
      
      Code$ + "Define Event" + #CRLF$ + #CRLF$
      
      ; global var windows
      If StartEnum( *parent )
         If is_window_( widget( ) )
            Name$ = GetClassString( widget( ) )
            If Trim( Name$, "#" ) = Name$
               Code$ + "Global " + Name$ + " = - 1" + #CRLF$
            Else
               FormWindow$ + Name$ + #CRLF$
            EndIf
         EndIf
         StopEnum( )
      EndIf
      
      ; enumeration windows
      If FormWindow$
         Code$ + "Enumeration FormWindow" + #CRLF$
         Code$ + "  " + FormWindow$
         Code$ + "EndEnumeration" + #CRLF$
      EndIf
      
      Code$ + #CRLF$
      
      ; global var gadgets
      If StartEnum( *parent )
         If Not is_window_( widget( ) )
            Name$ = GetClassString( widget( ) )
            If Trim( Name$, "#" ) = Name$
               Code$ + "Global " + Name$ + " = - 1" + #CRLF$
            Else
               FormGadget$ + Name$ + #CRLF$
            EndIf
         EndIf
         StopEnum( )
      EndIf
      
      ; enumeration gadgets
      If FormGadget$
         Code$ + "Enumeration FormGadget" + #CRLF$
         Code$ + "  " + FormGadget$
         Code$ + "EndEnumeration" + #CRLF$
      EndIf
      
      Code$ + #CRLF$
      
      If StartEnum( *parent )
         If Not is_window_( widget( ) )
            Events$ = GetEventsString( widget( ) )
            If Events$
               Code$ + Code::Code_Event_Procedure( 0, Trim( GetClass( widget( ) ), "#" ) + "_", "#PB_Event_Gadget", "" ) 
            EndIf
         EndIf
         StopEnum( )
      EndIf
      
      If StartEnum( *parent )
         If Not is_window_( widget( ) )
            Events$ = GetEventsString( widget( ) )
            If Events$
               Code$ + Code::Code_Event_Procedure( 0, GetClass( widget( ) ) + "_", Events$, "" ) 
            EndIf
         EndIf
         StopEnum( )
      EndIf
      
      
      If StartEnum( *parent )
         If is_window_( widget( ) )
            Element = widget( )
            If Not *mainWindow
               *mainWindow = widget( )
            EndIf
            
            ParentName$ = Trim( GetClassString( widget( ) ), "#" )
            
            Code$ + "Procedure Open_" + ParentName$ + "( )" + #CRLF$
            
            Define added_tab = - 1
            PushListPosition( widgets( ) )
            ForEach widgets( )
               If IsChild( widgets( ), Element ) Or widgets( ) = Element
                  Name$ = GetClassString( widgets( ) )
                  Code$ + "  "
                  
                  If widgets( )\BeforeWidget( )
                     If IsContainer(widgets( )\BeforeWidget( )) > 0 
                        Code$ + "CloseGadgetList( )" + #CRLF$
                        Code$ + "  "
                     EndIf
                  EndIf
                  
                  ; add parent item
                  If widgets( )\parent\tabbar
                     If added_tab <> widgets( )\TabIndex( ) 
                        added_tab = widgets( )\TabIndex( ) 
                        
                        Code$ + "AddGadgetItem( " + GetClassString( GetParent( widgets( ) ) ) + 
                                ", - 1" + 
                                ", " + Chr( '"' ) + GetItemText( GetParent( widgets( ) ), widgets( )\TabIndex( ) ) + Chr( '"' ) + 
                                " )  " + #CRLF$
                        
                        Code$ + "  "
                     EndIf
                  EndIf
                  
                  ; Function
                  If Trim( Name$, "#" ) = Name$
                     Select widgets( )\Type 
                        Case #__type_Window
                           Code$ + Name$ + " = " + "Open" + GetClass( widgets( ) ) + "( #PB_Any, "
                        Default
                           Code$ + Name$ + " = " + GetClass( widgets( ) ) + "Gadget( #PB_Any, "
                     EndSelect
                  Else
                     Select widgets( )\Type 
                        Case #__type_Window
                           Code$ + "Open" + GetClass( widgets( ) ) + "( " + Name$ + ", "
                        Default
                           Code$ + GetClass( widgets( ) ) + "Gadget( " + Name$ + ", "
                     EndSelect
                  EndIf
                  
                  ; Coordinate
                  Code$ + Str( X( widgets( ) ) ) + ", " + 
                          Str( Y( widgets( ) ) ) + ", " + 
                          Str( Width( widgets( ) ) ) + ", " + 
                          Str( Height( widgets( ) ) )
                  
                  ; Text
                  Select widgets( )\Type
                     Case #__type_Window, #__type_Button, #__type_String, #__type_Text, #__type_CheckBox, #__type_Option, #__type_Frame, 
                          #__type_HyperLink, #__type_ListIcon, #__type_Web, #__type_Date, #__type_ExplorerList, #__type_ExplorerTree, #__type_ExplorerCombo
                        
                        Code$ + ", " + Chr( '"' ) + GetText( widgets( ) ) + Chr( '"' )
                  EndSelect
                  
                  ; Param1
                  Select widgets( )\Type
                     Case #__type_Splitter : Code$ + ", " + GetAttribute( widgets( ), #PB_Splitter_FirstGadget )
                     Case #__type_ScrollArea : Code$ + ", " + GetAttribute( widgets( ), #PB_ScrollArea_InnerWidth )
                     Case #__type_Spin : Code$ + ", " + widgets( )\bar\Min
                     Case #__type_Progress : Code$ + ", " + widgets( )\bar\Min
                     Case #__type_Scroll : Code$ + ", " + widgets( )\bar\Min
                     Case #__type_Track : Code$ + ", " + widgets( )\bar\Min
                     Case #__type_HyperLink : Code$ + ", " + widgets( )\Color\Back
                        ; Case #__type_MDI : Code$ + ", " + widgets( )\SubMenu
                     Case #__type_Date : Code$ + ", "; + widgets( )\Date
                     Case #__type_Calendar : Code$ + ", "; + widgets( )\Date
                     Case #__type_ListIcon : Code$ + ", "; + widgets( )\FirstColumWidth
                     Case #__type_Scintilla : Code$ + ", "; + widgets( )\CallBack
                     Case #__type_Shortcut : Code$ + ", " ; + widgets( )\Shortcut
                     Case #__type_Image, #__type_ButtonImage 
                        If IsImage( widgets( )\Img\Image )
                           Code$ + ", ImageID( " + widgets( )\Img\Image + " )"
                        Else
                           Code$ + ", 0"
                        EndIf
                  EndSelect
                  
                  ; Param2
                  Select widgets( )\Type
                        ;Case #__type_MDI : Code$ + ", " + widgets( )\FirstMenuItem
                     Case #__type_Spin : Code$ + ", " + widgets( )\bar\Max
                     Case #__type_Track : Code$ + ", " + widgets( )\bar\Max
                     Case #__type_Scroll : Code$ + ", " + widgets( )\bar\Max
                     Case #__type_Progress : Code$ + ", " + widgets( )\bar\Max
                     Case #__type_ScrollArea : Code$ + ", " + GetAttribute( widgets( ), #PB_ScrollArea_InnerHeight )
                     Case #__type_Splitter : Code$ + ", " + GetAttribute( widgets( ), #PB_Splitter_SecondGadget )
                  EndSelect
                  
                  ; Param3
                  Select widgets( )\Type
                     Case #__type_Scroll : Code$ + ", " + GetAttribute( widgets( ), #PB_ScrollBar_PageLength )
                     Case #__type_ScrollArea 
                        If GetAttribute( widgets( ), #PB_ScrollArea_ScrollStep )
                           Code$ + ", " + GetAttribute( widgets( ), #PB_ScrollArea_ScrollStep )
                        EndIf
                  EndSelect
                  
                  ; Flags
                  Select widgets( )\Type
                     Case #__type_Panel, #__type_Web, #__type_IPAddress, #__type_Option, #__type_Scintilla, #__type_Shortcut
                     Default
                        If Trim( GetFlagsString( widgets( ) ), "|" )
                           Code$ + ", " + Trim( GetFlagsString( widgets( ) ), "|" )
                        EndIf
                  EndSelect
                  
                  Code$ + " )" + #CRLF$
                  
               EndIf
            Next
            PopListPosition( widgets( ) )
            
            ; Code$ + #CRLF$
            
            PushListPosition( widgets( ) )
            ForEach widgets( )
               If IsChild( widgets( ), Element )
                  Name$ = Trim( GetClassString( widgets( ) ), "#" )
                  
                  If widgets( )\Hide[1] 
                     Code$ + "  HideGadget( " + Name$ + ", #True )" + #CRLF$
                  EndIf
                  If widgets( )\Disable[1]
                     Code$ + "  DisableGadget( " + Name$ + ", #True )" + #CRLF$
                  EndIf
                  ;        If widgets( )\ToolTip\String$
                  ;         Code$ + "  GadgetToolTip( " + Name$ + ", " + #DQUOTE$ + widgets( )\ToolTip\String$ + #DQUOTE$ + " )" + #CRLF$
                  ;        EndIf
                  ;        If widgets( )\FontColorState
                  ;         Code$ + "  SetGadgetAttribute( " + Name$ + ", #PB_Gadget_FrontColor, $" + Hex( widgets( )\FontColor ) + " )" + #CRLF$
                  ;        EndIf
                  ;        If widgets( )\BackColorState
                  ;         Code$ + "  SetGadgetAttribute( " + Name$ + ", #PB_Gadget_BackColor, $" + Hex( widgets( )\BackColor ) + " )" + #CRLF$
                  ;        EndIf
                  ;        
                  ;        ;     Events$ = GetEventsString( widgets( ) )
                  ;        ;     Gadgets$ + GetClass( widgets( ) )
                  ;        ;     
                  ;        ;     If Events$
                  ;        ;       Code$ + Code::Code_BindGadgetEvent( 3, Events$, 0 );Gadgets$ )
                  ;        ;     EndIf
               EndIf
            Next
            PopListPosition( widgets( ) )
            
            Select widget( )\Type 
               Case #__type_Window
                  If GetEventsString( widget( ) )
                     Code$ + Code::Code_BindEvent( 3, "#PB_Event_" + GetEventsString( widget( ) ), ParentName$ + "_" )
                  EndIf
               Default
            EndSelect
            
            Code$ + "EndProcedure" + #CRLF$
            Code$ + #CRLF$
            
         EndIf
         StopEnum( )
      EndIf
      
      Code$ + "CompilerIf #PB_Compiler_IsMainFile" + #CRLF$
      ; Code$ + "  Open_" + Trim( GetClassString( *mainWindow ), "#" ) + "( )" + #CRLF$
      
      If StartEnum( *parent )
         If is_window_( widget( ) )
            Code$ + "  Open_" + Trim( GetClassString( widget( ) ), "#" ) + "( )" + #CRLF$
         EndIf
         StopEnum( )
      EndIf
      
      Code$ + #CRLF$
      
      Code$ + "  While IsWindow( " + GetClassString( *mainWindow ) + " )" + #CRLF$
      Code$ + "  Event = WaitWindowEvent( )" + #CRLF$ + #CRLF$
      Code$ + "  Select Event" + #CRLF$
      Code$ + "   Case #PB_Event_CloseWindow" + #CRLF$
      Code$ + "   CloseWindow( EventWindow( ) )" + #CRLF$
      Code$ + "  EndSelect" + #CRLF$ + #CRLF$
      Code$ + "  Select EventWindow( )" + #CRLF$
      
      If StartEnum( *parent, 0 )
         If is_window_( widget( ) )
            Code$ + "  Case " + GetClassString( widget( ) ) + #CRLF$
         EndIf
         StopEnum( )
      EndIf
      
      Code$ + "  EndSelect" + #CRLF$
      Code$ + "  Wend" + #CRLF$ + #CRLF$
      Code$ + "  End" + #CRLF$
      Code$ + "CompilerEndIf" + #CRLF$
      
      
      Code$ + #CRLF$ + #CRLF$
      
      ;   ;   SetClipboardText( Code$ )
      ;   
      ;   If IsGadget( IDE_Scintilla_Gadget )
      ;   ScintillaSendMessage( IDE_Scintilla_Gadget, #SCI_SETTEXT, 0, UTF8( Code$ ) )
      ;   Else
      ;   SetElementText( IDE_Scintilla_0, Code$ )
      ;   EndIf
      ;   
      ; 
      ;   
      ;   
      ; ;   Debug GetCurrentDirectory( )
      ; ;   Protected Name$ = ElementClass( CheckType ) + "_" + Str( CountElementType( CheckType ) )
      ; ;   Debug #PB_Compiler_Home + "Compilers\pbcompiler";Name$  ;     Puth$ = GetCurrentDirectory( ) + "Create_Code_Example\"
      ; ;                   ;     Debug GetPathPart( Puth$ )
      ; ;                   ;CLI> pbcompiler "C:\Project\Source\DLLSource.pb" /EXEChr( 34 ) + + Chr( 34 )
      ; ;                   ;RunProgram( #PB_Compiler_Home + "/Compilers/pbcompiler", Puth$ + " /QUIET /XP /UNICODE /ADMINISTRATOR /EXE " + ArrayWindow( 0 )\Name$ + ".exe" , GetPathPart( Puth$ ), #PB_Program_Open | #PB_Program_Read | #PB_Program_Hide )
      ; ;   RunProgram( #PB_Compiler_Home + "Compilers\pbcompiler", "/QUIET /XP /ADMINISTRATOR " + "" + Name$ + ".pb /EXE " + Name$ + ".exe", GetCurrentDirectory( ), #PB_Program_Open | #PB_Program_Read | #PB_Program_Hide )
      ; ;   RunProgram( "C:\" + Name$ + ".exe" )
      
   EndIf
   
   ProcedureReturn code$
EndProcedure

; - 
CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   
   If Open( 0, 0, 0, 322, 600, "enumeration widgets", #PB_Window_SystemMenu | #PB_Window_ScreenCentered )
      Define i, *parent._s_Widget
      
      For i = 1 To 3
         Window( 10 + i*30, i*140 - 120, 150, 95 + 2, "Window_" + Trim( Str( i ) ), #PB_Window_SystemMenu | #PB_Window_MaximizeGadget )  
         Container( 5, 5, 120 + 2, 85 + 2, #PB_Container_Flat )                  
         Button( 10, 10, 100, 30, "Button_" + Trim( Str( i + 10 ) ) )                  
         Button( 10, 45, 100, 30, "Button_" + Trim( Str( i + 20 ) ) )                 
         CloseList( )                               
      Next
      
      i = 4
      Window( 10 + i*30, i*140 - 120, 150, 95 + 2, "Window_" + Trim( Str( i ) ), #PB_Window_SystemMenu | #PB_Window_MaximizeGadget )  
      *parent = Panel( 5, 5, 120 + 2, 85 + 2 ) 
      AddItem( *parent, - 1, "item - 1" )
      Button( 10, 10, 100, 30, "Button14" )                  
      Button( 10, 45, 100, 30, "Button15" )                  
      AddItem( *parent, - 1, "item - 2" )
      Button( 10, 10, 100, 30, "Button16" )                  
      Button( 10, 45, 100, 30, "Button17" )                  
      AddItem( *parent, - 1, "item - 3" )
      Button( 10, 10, 100, 30, "Button18" )                  
      Button( 10, 45, 100, 30, "Button19" )                  
      CloseList( )                               
      SetState( *parent, 1 )
      
      If StartEnum( root( ) )
         SetClassString( widget( ), GetClass( widget( ) ) + "_" + CountType( widget( ), - 1 ) )
         StopEnum( )
      EndIf
      
      ;   If StartEnum( root( ) )
      ;    Debug GetClassString( widget( ) )
      ;    StopEnum( )
      ;   EndIf
      
      
      
      ;   Debug " - - - enumerate all widgets - - - "
      ;   If StartEnum( root( ) )
      ;    If is_window_( widget( ) )
      ;     Debug "   window " + Index( widget( ) )
      ;    Else
      ;     Debug "   gadget - " + Index( widget( ) )
      ;    EndIf
      ;    StopEnum( )
      ;   EndIf
      ;   
      ;   Debug " - - - enumerate all gadgets - - - "
      ;   If StartEnum( root( ) )
      ;    If Not is_window_( widget( ) )
      ;     Debug "   gadget - " + Index( widget( ) )
      ;    EndIf
      ;    StopEnum( )
      ;   EndIf
      ;   
      ;   Debug " - - - enumerate all windows - - - "
      ;   If StartEnum( root( ) )
      ;    If is_window_( widget( ) )
      ;     Debug "   window " + Index( widget( ) )
      ;    EndIf
      ;    StopEnum( )
      ;   EndIf
      ;   
      ;   Define Index = 12
      ;   *parent = ID( Index )
      ;   
      ;   Debug " - - - enumerate all ( window=" + Str( Index ) + " ) gadgets - - - "
      ;   If StartEnum( *parent )
      ;    Debug "   gadget - " + Index( widget( ) )
      ;    StopEnum( )
      ;   EndIf
      ;   
      ;   Index = 13
      ;   *parent = ID( Index )
      ;   Define item = 1
      ;   
      ;   Debug " - - - enumerate all ( gadget=" + Str( Index ) + " ) ( item=" + Str( item ) + " ) gadgets - - - "
      ;   If StartEnum( *parent, item )
      ;    Debug "   gadget - " + Index( widget( ) )
      ;    StopEnum( )
      ;   EndIf
      
   EndIf
   
   Define *root = root( )
   If Open( 1, 0, 0, 322, 600, "enumeration widgets", #PB_Window_SystemMenu | #PB_Window_ScreenCentered )
      ResizeWindow( 0, WindowX( 0 ) - WindowWidth( 0 )/2, #PB_Ignore, #PB_Ignore, #PB_Ignore )
      ResizeWindow( 1, WindowX( 1 ) + WindowWidth( 1 )/2, #PB_Ignore, #PB_Ignore, #PB_Ignore )
      
      Define *g = Editor( 0, 0, 0, 0, #__flag_autosize )
      
      Define code$ = GeneratePBCode( *root )
      
      SetText( *g, code$ )
      Repeat : Until WaitWindowEvent( ) = #PB_Event_CloseWindow
   EndIf
   
   
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 7
; Folding = -------------
; EnableXP
; DPIAware