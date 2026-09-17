IncludePath "../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
   Global._s_widget *g_OBJECT, *g_TYPE, *g_FREE
   Global  i, vert=100, horiz=100, Width=400, Height=400
   Global cr.s = #LF$, Text.s = "Vertical & Horizontal" + cr + "   Centered   Text in   " + cr + "Multiline StringGadget"
   
   Procedure widget_create( *parent._s_widget, type$, X.l,Y.l, Width.l, Height.l )
      Protected *new._s_widget, Flag.q ;= #__flag_Textmultiline
      
      Protected newtype$
      Protected AddItem
      Protected SetState
      
      If *parent > 0 
         OpenList( *parent, CountItems( *parent ) - 1 )
         type$ = LCase( Trim( type$ ) )
         

         ; create elements
         Select type$
            Case "window"    
               If Type( *parent ) = #__Type_MDI
                  *new = AddItem( *parent, #PB_Any, type$, - 1, Flag | #PB_Window_NoActivate )
                  Resize( *new, X, Y, Width, Height )
               Else
                  Flag | #PB_Window_SystemMenu | #PB_Window_MaximizeGadget | #PB_Window_MinimizeGadget | #PB_Window_NoActivate
                  *new = Window( X,Y,Width,Height, type$, Flag, *parent )
               EndIf
               
            Case "scrollarea"  : *new = ScrollArea( X,Y,Width,Height, Width*2, Height*2, 1, Flag ) : CloseList( ) ; 1 
            Case "container"   : *new = Container( X,Y,Width,Height, Flag ) : CloseList( )
               
            Case "button"      : *new = Button(       X, Y, Width, Height, type$, Flag ) 
            Case "string"        : *new = String(       X, Y, Width, Height, type$, Flag )
            Case "text"          : *new = Text(         X, Y, Width, Height, type$, Flag )
            Case "checkbox"      : *new = CheckBox(     X, Y, Width, Height, type$, Flag ) 
               ; Case "web"           : *new = Web(          X, Y, Width, Height, type$, flag )
            Case "explorerlist"  : *new = ExplorerList( X, Y, Width, Height, type$, Flag )                                                                           
               ; Case "explorertree"  : *new = ExplorerTree( X, Y, Width, Height, type$, flag )                                                                           
               ; Case "explorercombo" : *new = ExplorerCombo(X, Y, Width, Height, type$, flag )                                                                          
            Case "frame"         : *new = Frame(        X, Y, Width, Height, type$, Flag )                                                                                  
               
               ; Case "date"          : *new = Date(         X, Y, Width, Height, type$, Param1, flag )         ; 2            
            Case "hyperlink"     : *new = HyperLink(    X, Y, Width, Height, type$, $00FF5DE6, Flag )                                                          
               
            Case "scroll"        : *new = Scroll(       X, Y, Width, Height, 0, 10, 0, Flag ) : SetState = 1  ; bar                                                             
            Case "progress"      : *new = Progress(     X, Y, Width, Height, 0, 10, Flag ) : SetState = 1        ; bar                                                           
            Case "track"         : *new = Track(        X, Y, Width, Height, 0, 10, Flag ) : SetState = 1          ; bar                                                                           
            Case "spin"          : *new = Spin(         X, Y, Width, Height, 0, 10, Flag )  : SetState = 1                                                                            
            Case "splitter"      : *new = Splitter(     X, Y, Width, Height, -1, -1, Flag )                ; :Debug ""+Param1 +" "+ Param2 ;                                                          
               
            Case "mdi"           : *new = MDI(          X, Y, Width, Height, Flag )                                ;  , Param1, Param2                                                                          
            Case "image"         : *new = Image(        X, Y, Width, Height, -1, Flag )                                                                                                     
            Case "buttonimage"   : *new = ButtonImage(  X, Y, Width, Height, -1, Flag )                                                                                                 
               
               ; Case "calendar"      : *new = Calendar(     X, Y, Width, Height, Param1, flag )                 ; 1                                                 
               
            Case "listicon"      : *new = ListIcon(     X, Y, Width, Height, type$, Width, Flag ) ;: AddItem = 1                                                        
            Case "panel"       : *new = Panel( X,Y,Width,Height, Flag ) : CloseList( ) : AddItem = 1
            Case "listview"      : *new = ListView(     X, Y, Width, Height, Flag ) : AddItem = 1                                                                                                                    
            Case "combobox"      : *new = ComboBox(     X, Y, Width, Height, Flag ) : AddItem = 1 
            Case "editor"        : *new = Editor(       X, Y, Width, Height, Flag ) : AddItem = 1                                                                                                                           
            Case "tree"          : *new = Tree(         X, Y, Width, Height, Flag ) : AddItem = 1                                                                                                                             
               ; Case "canvas"        : *new = Canvas(       X, Y, Width, Height, flag )                                                                                                                          
               
            Case "option"        : *new = Option(       X, Y, Width, Height, type$ )
               ; Case "scintilla"     : *new = Scintilla(    X, Y, Width, Height, Param1 )
               ; Case "shortcut"      : *new = Shortcut(     X, Y, Width, Height, Param1 )
            Case "ipaddress"     : *new = IPAddress(    X, Y, Width, Height )
               
         EndSelect
         
         If *new
            newtype$ = type$+"_"+CountType( *new )
            SetClass( *new, UCase(newtype$) )
            SetText( *new, newtype$ )
            
            ;
            SetBackColor( *new, $FFF1F1F1 ) : *new\ChangeColor = 0
            
            If AddItem
               Protected i
               For i = 0 To 3
                  AddItem(*new, -1, GetClass(*new)+"_"+Str(i))
               Next
            EndIf
            
            If SetState 
               SetState(*new, 5)
            EndIf
         EndIf
         
         CloseList( ) 
      EndIf
      
      ProcedureReturn *new
   EndProcedure
   
   Procedure all_events()
      Select WidgetEvent( )
         Case #__event_Change
            If EventWidget( ) = *g_TYPE
               If *g_OBJECT
                  Free( @*g_OBJECT )
               EndIf
               *g_OBJECT = widget_create(Root(), GetItemText( *g_TYPE, GetState( *g_TYPE)), 100, 100, 250, 200);, Text, 0,0,0, #PB_Button_Toggle|#__flag_Textmultiline) 
               If *g_OBJECT
                  PostRepaint(*g_OBJECT\root)
               EndIf
            EndIf
            
         Case #__event_Down
            ClearDebugOutput()
;             If EventWidget( ) = *g_FREE
;                Free(@*g_OBJECT)
;             EndIf
            
         Case #__event_Free
            Debug "    do free - [" + EventWidget( )\class +"]"
            ProcedureReturn #True
      EndSelect
   EndProcedure
   
   If Open( 0, 0, 0, Width+205, Height+30, "flag", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      ; a_init(Root())
      
      *g_TYPE = ListView(Width+45, 10, 150, Height+10) 
      
      For i=0 To 33-3 : AddItem(*g_TYPE, -1, ClassFromType(i)) : Next
;       ;AddItem(*g_TYPE, -1, "Panel")
;       AddItem(*g_TYPE, -1, "Progress")
;       AddItem(*g_TYPE, -1, "Button")
;       ;AddItem(*g_TYPE, -1, "ComboBox")
;       ;AddItem(*g_TYPE, -1, "Tree")
      
      SetState(*g_TYPE, 1)
      ;*g_FREE = Button(Width+45, Height-10, 150, 30, "free")
      
      ;
      WaitClose( @all_events( ))
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.30 - C Backend (MacOS X - x64)
; CursorPosition = 129
; FirstLine = 117
; Folding = ---
; EnableXP
; DPIAware