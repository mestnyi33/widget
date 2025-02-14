XIncludeFile "../widgets.pbi"
XIncludeFile "include/code_generate.pbi"

UseWidgets( )


Global NewMap FlagsString.s( )
Global NewMap EventsString.s( )
Global NewMap ImagePuchString.s( )
Global NewMap ClassString.s( )

Procedure.s GetClassString( Element )
   
   ProcedureReturn ClassFromType( Type(Element) )
   ;ProcedureReturn StringField( GetClass(Element), 1, "_" )
   ;ProcedureReturn ULCase(StringField( GetClass(Element), 1, "_" ))
   
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
Procedure.s GenerateCODE( *this._s_WIDGET, FUNCTION$, Space$ = "" )
   Protected Result$, ID$, param1$, param2$, param3$, Text$, flag$, Class$, Name$
   Static TabIndex =- 1
   
   If FUNCTION$ = "CloseGadgetList"
      If IsContainer( *this ) > 0 
         If Not is_window_( *this )
            Result$ + Space$ + FUNCTION$ + "( )" + #CRLF$
         EndIf
      EndIf 
   EndIf
   
   If FUNCTION$ = "AddGadgetItem"
      If *this\parent\tabbar
         If TabIndex <> *this\TabIndex( ) 
            TabIndex = *this\TabIndex( ) 
            
            Result$ + FUNCTION$ + "( " + GetClass( *this\parent ) + 
                      ", - 1" + 
                      ", " + Chr( '"' ) + GetItemText( *this\parent, TabIndex ) + Chr( '"' ) + 
                      " )  " + #CRLF$
            
            Result$ + Space$
         EndIf
      EndIf
   EndIf
   
   
   If FUNCTION$ = "STATE"
      Name$ = GetClass( *this )
      ;
      If Hide( *this)
         Result$ + Space$ + "HideGadget( " + Name$ + ", #True )" + #CRLF$
      EndIf
      If Disable( *this)
         Result$ + Space$ + "DisableGadget( " + Name$ + ", #True )" + #CRLF$
      EndIf
      If GetState( *this) > 0
         Result$ + Space$ + "SetGadgetState( " + Name$ + ", "+ GetState( *this) + " )" + #CRLF$
      Else
         ; Это для тех кто гаджетов которые принимают [0]
         Select widget( )\Type 
            Case #__type_Panel
               If GetState( *this) = 0
                  Result$ + Space$ + "SetGadgetState( " + Name$ + ", "+ GetState( *this) + " )" + #CRLF$
               EndIf
         EndSelect
      EndIf
   EndIf
   
   If FUNCTION$ = "FUNCTION"
      ;flag$ = FlagFromFlag( *this\type, *this\flag )
      Class$ = GetClassString( *this )
      Name$ = GetClass( *this )
      Result$ + Space$
      
      
      ;    Select Asc( Class$ )
      ;       Case '#'        : ID$ = Class$              
      ;       Case '0' To '9' : ID$ = Chr( Asc( Class$ ) ) 
      ;       Default         : ID$ = "#PB_Any"             
      ;    EndSelect
      ;    
      
      ;\\ close last list
      If *this\BeforeWidget( )
         Result$ + GenerateCODE( *this\BeforeWidget( ), "CloseGadgetList" )
         
         ;\\
         If IsContainer(*this) > 0 
            If Not is_window_( *this )
               Result$ + Space$ + #CRLF$
               Result$ + Space$ 
            EndIf
         EndIf
      EndIf
      
      ;\\ add parent item
      Result$ + GenerateCODE( *this, "AddGadgetItem", Space$ ) 
      
      
      ;\\ Function PB
      If Trim( Name$, "#" ) = Name$
         Select *this\Type 
            Case #__type_Window
               Result$ + Name$ + " = " + "Open" + Class$ + "( #PB_Any, "
            Default
               Result$ + Name$ + " = " + Class$ + "Gadget( #PB_Any, "
         EndSelect
      Else
         Select *this\Type 
            Case #__type_Window
               Result$ + "Open" + Class$ + "( " + Name$ + ", "
            Default
               Result$ + Class$ + "Gadget( " + Name$ + ", "
         EndSelect
      EndIf
      
      ; Coordinate
      Result$ + Str( X( *this ) ) + ", " + 
                Str( Y( *this ) ) + ", " + 
                Str( Width( *this ) ) + ", " + 
                Str( Height( *this ) )
      
      ; Text
      Select *this\Type
         Case #__type_Window, #__type_Button, #__type_String, #__type_Text, #__type_CheckBox, #__type_Option, #__type_Frame, 
              #__type_HyperLink, #__type_ListIcon, #__type_Web, #__type_Date, #__type_ExplorerList, #__type_ExplorerTree, #__type_ExplorerCombo
            
            Result$ + ", " + Chr( '"' ) + GetText( *this ) + Chr( '"' )
            ; Result$ + ", " + Chr( 34 ) + GetText( *this ) + Chr( 34 )
            
      EndSelect
      
      ; Param1
      Select *this\Type
         Case #__type_Splitter : Result$ + ", " + GetAttribute( *this, #PB_Splitter_FirstGadget )
         Case #__type_ScrollArea : Result$ + ", " + GetAttribute( *this, #PB_ScrollArea_InnerWidth )
         Case #__type_Spin : Result$ + ", " + *this\bar\Min
         Case #__type_Progress : Result$ + ", " + *this\bar\Min
         Case #__type_Scroll : Result$ + ", " + *this\bar\Min
         Case #__type_Track : Result$ + ", " + *this\bar\Min
         Case #__type_HyperLink : Result$ + ", " + *this\Color\Back
            ; Case #__type_MDI : Result$ + ", " + *this\SubMenu
         Case #__type_Date : Result$ + ", "; + *this\Date
         Case #__type_Calendar : Result$ + ", "; + *this\Date
         Case #__type_ListIcon : Result$ + ", "; + *this\FirstColumWidth
         Case #__type_Scintilla : Result$ + ", "; + *this\CallBack
         Case #__type_Shortcut : Result$ + ", " ; + *this\Shortcut
         Case #__type_Image, #__type_ButtonImage 
            If IsImage( *this\Img\Image )
               Result$ + ", ImageID( " + *this\Img\Image + " )"
            Else
               Result$ + ", 0"
            EndIf
      EndSelect
      
      ; Param2
      Select *this\Type
            ;Case #__type_MDI : Result$ + ", " + *this\FirstMenuItem
         Case #__type_Spin : Result$ + ", " + *this\bar\Max
         Case #__type_Track : Result$ + ", " + *this\bar\Max
         Case #__type_Scroll : Result$ + ", " + *this\bar\Max
         Case #__type_Progress : Result$ + ", " + *this\bar\Max
         Case #__type_ScrollArea : Result$ + ", " + GetAttribute( *this, #PB_ScrollArea_InnerHeight )
         Case #__type_Splitter : Result$ + ", " + GetAttribute( *this, #PB_Splitter_SecondGadget )
      EndSelect
      
      ; Param3
      Select *this\Type
         Case #__type_Scroll : Result$ + ", " + GetAttribute( *this, #PB_ScrollBar_PageLength )
         Case #__type_ScrollArea 
            If GetAttribute( *this, #PB_ScrollArea_ScrollStep )
               Result$ + ", " + GetAttribute( *this, #PB_ScrollArea_ScrollStep )
            EndIf
      EndSelect
      
      ; Flags
      Select *this\Type
         Case #__type_Panel, #__type_Web, #__type_IPAddress, #__type_Option, #__type_Scintilla, #__type_Shortcut
         Default
            If Trim( GetFlagsString( *this ), "|" )
               Result$ + ", " + Trim( GetFlagsString( *this ), "|" )
            EndIf
      EndSelect
      
      Result$ + " )"
   EndIf
   
   ProcedureReturn Result$
EndProcedure

Procedure.s GeneratePBCode( *parent._s_WIDGET, Space = 3 )
   Protected Type
   Protected Count
   Protected Image
   Protected Parent
   Protected *Element._s_WIDGET
   Protected Space$ = Space(space)
   Protected Name$, Class$, Code$, FormWindow$, FormGadget$, Gadgets$, Windows$, Events$, Functions$
   Static JPEGPlugin$, JPEG2000Plugin$, PNGPlugin$, TGAPlugin$, TIFFPlugin$
   Protected *mainWindow._s_WIDGET
   
   ; is *Element
   If IsChildrens( *parent )
      Code$ + "EnableExplicit" + #CRLF$ + #CRLF$
      
      If StartEnum( *parent, 0 )
         Image = GetImage( *Element )
         
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
      
      ; global var windows
      If StartEnum( *parent )
         If is_window_( widget( ) )
            Name$ = GetClass( widget( ) )
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
         Code$ + Space$ + FormWindow$
         Code$ + "EndEnumeration" + #CRLF$
      EndIf
      
      Code$ + #CRLF$
      
      ; global var gadgets
      If StartEnum( *parent )
         If Not is_window_( widget( ) )
            Name$ = GetClass( widget( ) )
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
         Code$ + Space$ + FormGadget$
         Code$ + "EndEnumeration" + #CRLF$
      EndIf
      
      Code$ + #CRLF$
      
      If StartEnum( *parent )
         ;If Not is_window_( widget( ) )
            Events$ = GetEventsString( widget( ) )
            If Events$
               Code$ + Code::GenerateBindEventProcedure( 0, Trim( GetClass( widget( ) ), "#" ) , Events$, "" ) 
            EndIf
         ;EndIf
         StopEnum( )
      EndIf
      
      
      If StartEnum( *parent )
         If is_window_( widget( ) )
            *Element = widget( )
            
            If Not *mainWindow
               *mainWindow = *Element
            EndIf
            
            ;\\
            Code$ + "Procedure Open_" + Trim( GetClass( widget( ) ), "#" ) + "( )" + #CRLF$
            
            ;\\ 
            Code$ + GenerateCODE( widgets( ), "FUNCTION", Space( ( Level(widgets( )) - Level(*parent) ) * space) ) + #CRLF$
            If StartEnum( *Element )
               Code$ + GenerateCODE( widgets( ), "FUNCTION", Space( ( Level(widgets( )) - Level(*parent) ) * space) ) + #CRLF$
               StopEnum( )
            EndIf
            
            ;\\
            If *parent\LastWidget( ) And 
               *parent\LastWidget( )\LastWidget( )
               Code$ + GenerateCODE( *parent\LastWidget( )\LastWidget( ), "CloseGadgetList", Space( ( Level(*parent\LastWidget( )\LastWidget( )) - Level(*parent) ) * space) )
            EndIf
            
            ;\\
            If StartEnum( *Element )
               If GenerateCODE( widget( ), "STATE" )
                  Code$ + Space$ + #CRLF$
                  Break
               EndIf
               StopEnum( )
            EndIf
            
            ;\\
            If StartEnum( *Element )
               Code$ + GenerateCODE( widget( ), "STATE", Space$ + Space( ( Level(widget( )) - Level(*Element) ) * space) )
            
               
               ;        ;     Events$ = GetEventsString( widgets( ) )
               ;        ;     Gadgets$ + GetClassString( widgets( ) )
               ;        ;     
               ;        ;     If Events$
               ;        ;       Code$ + Code::GenerateBindGadgetEvent( 3, Events$, 0 );Gadgets$ )
               ;        ;     EndIf
               StopEnum( )
            EndIf
            
            Select widget( )\Type 
               Case #__type_Window
                  If GetEventsString( widget( ) )
                     Code$ + #CRLF$
                     Code$ + Code::GenerateBindEvent( ( Level(widget( )) - Level(*parent) ) * space, GetEventsString( widget( ) ), GetClass( widget( ) ) )
                  EndIf
               Default
            EndSelect
            
            Code$ + "EndProcedure" + #CRLF$
            Code$ + #CRLF$
            
         EndIf
         StopEnum( )
      EndIf
      
      Code$ + "CompilerIf #PB_Compiler_IsMainFile" + #CRLF$
      ; Code$ + "  Open_" + Trim( GetClass( *mainWindow ), "#" ) + "( )" + #CRLF$
      
      If StartEnum( *parent )
         If is_window_( widget( ) )
            Code$ + Space$ + "Open_" + Trim( GetClass( widget( ) ), "#" ) + "( )" + #CRLF$
         EndIf
         StopEnum( )
      EndIf
      
      Code$ + #CRLF$
      
      Code$ + Space$ + "Define Event" + #CRLF$
      
      Code$ + Space$ + "While IsWindow( " + GetClass( *mainWindow ) + " )" + #CRLF$
      Code$ + Space$ + Space$ + "Event = WaitWindowEvent( )" + #CRLF$ + #CRLF$
      Code$ + Space$ + Space$ + "Select Event" + #CRLF$
      Code$ + Space$ + Space$ + Space$ + "Case #PB_Event_CloseWindow" + #CRLF$
      Code$ + Space$ + Space$ + Space$ + "CloseWindow( EventWindow( ) )" + #CRLF$
      Code$ + Space$ + Space$ + "EndSelect" + #CRLF$ + #CRLF$
      Code$ + Space$ + Space$ + "Select EventWindow( )" + #CRLF$
      
      If StartEnum( *parent, 0 )
         If is_window_( widget( ) )
            Code$ + Space$ + Space$ + Space$ + "Case " + GetClass( widget( ) ) + #CRLF$
         EndIf
         StopEnum( )
      EndIf
      
      Code$ + Space$ + Space$ + "EndSelect" + #CRLF$
      Code$ + Space$ + "Wend" + #CRLF$ + #CRLF$
      Code$ + Space$ + "End" + #CRLF$
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
      ; ;   Debug #PB_Compiler_Home + "Compilers\pbcompiler";Name$  ;     Puth$ = GetCurrentDirectory( ) + "Create_GenerateExample\"
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
      
      i = 1
      Window( 10 + i*30, i*140 - 120, 255, 95 + 2, "Window_" + Trim( Str( i ) ), #PB_Window_SystemMenu | #PB_Window_MaximizeGadget )  
      SetEventsString(widget( ), "#PB_Event_Gadget|#PB_Event_SizeWindow")
      
      Container( 5, 5, 120 + 2, 85 + 2, #PB_Container_Flat )                  
      Button( 10, 10, 100, 30, "Button_" + Trim( Str( i + 10 ) ) )                  
      Button( 10, 45, 100, 30, "Button_" + Trim( Str( i + 20 ) ) )                 
      CloseList( )                               
      Container( 127, 5, 120 + 2, 85 + 2, #PB_Container_Flat )                  
      Button( 10, 10, 100, 30, "Button_" + Trim( Str( i + 10 ) ) )                  
      Button( 10, 45, 100, 30, "Button_" + Trim( Str( i + 20 ) ) )                 
      CloseList( )                               
      
      i = 2 
      Window( 10 + i*30, i*140 - 120, 255, 95 + 2, "Window_" + Trim( Str( i ) ), #PB_Window_SystemMenu | #PB_Window_MaximizeGadget )  
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
      
      *parent = Panel( 127, 5, 120 + 2, 85 + 2 ) 
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
         SetClass( widget( ), UCase(GetClassString( widget( ) )) + "_" + CountType( widget( ), - 1 ) )
         ; SetClass( widget( ), GetClassString( widget( ) ) + "_" + CountType( widget( ), - 1 ) )
         
         StopEnum( )
      EndIf
      
      ;   If StartEnum( root( ) )
      ;    Debug GetClass( widget( ) )
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
; CursorPosition = 342
; FirstLine = 284
; Folding = -------+-----
; EnableXP
; DPIAware