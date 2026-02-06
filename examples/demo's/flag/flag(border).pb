IncludePath "../../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
   Global._s_widget *g_OBJECT, *g_TYPE, *g_FLAG
   Global  i, vert=100, horiz=100, Width=450, Height=400
   Global cr.s = #LF$, Text.s = "Vertical & Horizontal" + cr + "   Centered   Text in   " + cr + "Multiline StringGadget"
   
   Procedure widget_create( *parent._s_widget, type$, X.l,Y.l, Width.l=#PB_Ignore, Height.l=#PB_Ignore, text$="", Param1=0, Param2=0, Param3=0, Flag.q = 0 )
      Protected *new._s_widget
      ; flag.i | #__flag_NoFocus
      Protected newtype$
      
      If *parent > 0 
         OpenList( *parent, CountItems( *parent ) - 1 )
         type$ = LCase( Trim( type$ ) )
         
         ; defaul width&height
         If type$ = "scrollarea" Or
            type$ = "container" Or
            type$ = "panel"
            
            If Width = #PB_Ignore
               Width = 200
            EndIf
            If Height = #PB_Ignore
               Height = 150
            EndIf
            
            If Param3 = 0
               If type$ = "scrollarea"
                  Param1 = Width
                  Param2 = Height
                  Param3 = 5
               EndIf
            EndIf
            
         Else
            If Width = #PB_Ignore
               Width = 100
            EndIf
            If Height = #PB_Ignore
               Height = 30
            EndIf
         EndIf
         
         ; create elements
         Select type$
            Case "window"    
               If GetType( *parent ) = #__Type_MDI
                  *new = AddItem( *parent, #PB_Any, text$, - 1, Flag | #PB_Window_NoActivate )
                  Resize( *new, X, Y, Width, Height )
               Else
                  Flag | #PB_Window_SystemMenu | #PB_Window_MaximizeGadget | #PB_Window_MinimizeGadget | #PB_Window_NoActivate
                  *new = Window( X,Y,Width,Height, text$, Flag, *parent )
               EndIf
               
            Case "scrollarea"  : *new = ScrollArea( X,Y,Width,Height, Param1, Param2, Param3, Flag ) : CloseList( ) ; 1 
            Case "container"   : *new = Container( X,Y,Width,Height, Flag ) : CloseList( )
            Case "panel"       : *new = Panel( X,Y,Width,Height, Flag ) : CloseList( )
               
            Case "button"      : *new = Button(       X, Y, Width, Height, text$, Flag ) 
            Case "string"        : *new = String(       X, Y, Width, Height, text$, Flag )
            Case "text"          : *new = Text(         X, Y, Width, Height, text$, Flag )
            Case "checkbox"      : *new = CheckBox(     X, Y, Width, Height, text$, Flag ) 
               ; Case "web"           : *new = Web(          X, Y, Width, Height, text$, flag )
            Case "explorerlist"  : *new = ExplorerList( X, Y, Width, Height, text$, Flag )                                                                           
               ; Case "explorertree"  : *new = ExplorerTree( X, Y, Width, Height, text$, flag )                                                                           
               ; Case "explorercombo" : *new = ExplorerCombo(X, Y, Width, Height, text$, flag )                                                                          
            Case "frame"         : *new = Frame(        X, Y, Width, Height, text$, Flag )                                                                                  
               
               ; Case "date"          : *new = Date(         X, Y, Width, Height, text$, Param1, flag )         ; 2            
            Case "hyperlink"     : *new = HyperLink(    X, Y, Width, Height, text$, Param1, Flag )                                                          
            Case "listicon"      : *new = ListIcon(     X, Y, Width, Height, text$, Param1, Flag )                                                       
               
            Case "scroll"        : *new = Scroll(       X, Y, Width, Height, Param1, Param2, Param3, Flag )  ; bar                                                             
               
            Case "progress"      : *new = Progress(     X, Y, Width, Height, Param1, Param2, Flag )          ; bar                                                           
            Case "track"         : *new = Track(        X, Y, Width, Height, Param1, Param2, Flag )          ; bar                                                                           
            Case "spin"          : *new = Spin(         X, Y, Width, Height, Param1, Param2, Flag )                                                                             
            Case "splitter"      : *new = Splitter(     X, Y, Width, Height, Param1, Param2, Flag )                ; :Debug ""+Param1 +" "+ Param2 ;                                                          
            Case "mdi"           : *new = MDI(          X, Y, Width, Height, Flag )                                ;  , Param1, Param2                                                                          
            Case "image"         : *new = Image(        X, Y, Width, Height, Param1, Flag )                                                                                                     
            Case "buttonimage"   : *new = ButtonImage(  X, Y, Width, Height, Param1, Flag )                                                                                                 
               
               ; Case "calendar"      : *new = Calendar(     X, Y, Width, Height, Param1, flag )                 ; 1                                                 
               
            Case "listview"      : *new = ListView(     X, Y, Width, Height, Flag )                                                                                                                       
            Case "combobox"      : *new = ComboBox(     X, Y, Width, Height, Flag ) 
            Case "editor"        : *new = Editor(       X, Y, Width, Height, Flag )                                                                                                                          
            Case "tree"          : *new = Tree(         X, Y, Width, Height, Flag )                                                                                                                            
               ; Case "canvas"        : *new = Canvas(       X, Y, Width, Height, flag )                                                                                                                          
               
            Case "option"        : *new = Option(       X, Y, Width, Height, text$ )
               ; Case "scintilla"     : *new = Scintilla(    X, Y, Width, Height, Param1 )
               ; Case "shortcut"      : *new = Shortcut(     X, Y, Width, Height, Param1 )
            Case "ipaddress"     : *new = IPAddress(    X, Y, Width, Height )
               
         EndSelect
         
         If *new
            ; Debug ""+*parent\class +" "+ *new\class
            ;\\ первый метод формирования названия переменной
            newtype$ = type$+"_"+CountType( *new )
            ;Debug ""+*parent +" "+ newtype$
            ;\\ второй метод формирования названия переменной
            ;          If *parent = ide_design_panel_MDI
            ;             newtype$ = ClassFromType( *new\type )+"_"+CountType( *new , 2 )
            ;          Else
            ;             newtype$ = ClassFromType( *parent\type )+"_"+CountType( *parent, 2 )+"_"+Class( *new )+"_"+CountType( *new , 2 )
            ;          EndIf
            ;\\
            SetClass( *new, UCase(newtype$) )
            SetText( *new, newtype$ )
            
            ;
            If IsContainer( *new )
               ;EnableDrop( *new, #PB_Drop_Private, #PB_Drag_Copy, #_DD_CreateNew|#_DD_reParent|#_DD_CreateCopy|#_DD_Group )
               ;           EnableDrop( *new, #PB_Drop_Private, #PB_Drag_Copy, #_DD_CreateNew )
               ;           EnableDrop( *new, #PB_Drop_Private, #PB_Drag_Copy, #_DD_reParent )
               ;           EnableDrop( *new, #PB_Drop_Private, #PB_Drag_Copy, #_DD_CreateCopy )
               ;           EnableDrop( *new, #PB_Drop_Private, #PB_Drag_Copy, #_DD_Group )
               If is_window_( *new )
                  ;                Protected *imagelogo = CatchImage( #PB_Any, ?imagelogo ); group_bottom )
                  ;                CompilerIf #PB_Compiler_DPIAware
                  ;                   ResizeImage(*imagelogo, DPIScaled(ImageWidth(*imagelogo)), DPIScaled(ImageHeight(*imagelogo)), #PB_Image_Raw)
                  ;                CompilerEndIf
                  ;                
                  ; ;                If AddImages( *imagelogo )
                  ; ;                   ;images( )\file$ = ReplaceString( #PB_Compiler_Home, "\", "/" ) + "ide/include/images/group/group_bottom.png"
                  ; ;                   images( )\file$ = "ide/include/images/group/group_bottom.png"
                  ; ;                   images( )\id$ = "*imagelogo"
                  ; ;                EndIf
                  ;                
                  ;                SetImage( *new, *imagelogo )
                  
                  If Not Flag & #__flag_NoFocus 
                     a_set(*new, #__a_full, (14))
                  EndIf
                  SetBackColor( *new, $FFECECEC )
                  ;
                  ;Properties_Updates( *new, "Resize" )
                  ;Bind( *new, @widget_events( ) )
               Else
                  If Not Flag & #__flag_NoFocus 
                     a_set(*new, #__a_full, (10))
                  EndIf
                  SetBackColor( *new, $FFF1F1F1 )
               EndIf 
               
               ; 
               *new\ChangeColor = 0
            Else
               If Not Flag & #__flag_NoFocus 
                  a_set(*new, #__a_full)
               EndIf
            EndIf
            
            ;Bind( *new, @widget_events( ), #__event_Resize )
         EndIf
         
         CloseList( ) 
      EndIf
      
      ProcedureReturn *new
   EndProcedure
   
   Procedure$ GetCheckedText(Gadget)
      Protected i, Result$, CountItems = CountItems(Gadget)
      
      For i = 0 To CountItems - 1
         If GetItemState(Gadget, i) & #PB_Tree_Checked  
            Result$ + GetItemText(Gadget, i)+"|"
         EndIf
      Next
      
      ProcedureReturn Trim(Result$, "|")
   EndProcedure
   
   Procedure SetCheckedText(Gadget, Text$)
      Protected i,ii
      Protected CountItems = CountItems(Gadget)
      Protected CountString = CountString(Text$, "|")
      
      For i = 0 To CountString
         For ii = 0 To CountItems - 1
            If GetItemText(Gadget, ii) = Trim( StringField( Text$, (i + (1)), "|"))
               SetItemState(Gadget, ii, #PB_Tree_Checked) 
            EndIf
         Next
      Next
   EndProcedure
   
   Procedure Set(Gadget, Object)
      Protected i, state, Flag.q, flag$, count
      ;i = WidgetEventItem( ) ; GetState(Gadget)
      count = CountItems(gadget)
      ;       ;
      ;       For i = 0 To count
      ;          flag = MakeValue( GetItemText( Gadget, i ))
      ;          state = Bool( GetItemState( Gadget, i ) & #PB_Tree_Checked )
      ;          Flag( Object, flag, state )
      ;       Next
      
      flag$ = GetCheckedText( Gadget )
      
      i = WidgetEventItem( ) 
      flag$ = GetItemText( Gadget, i )
      Flag = MakeValue( flag$ )
      state = Bool( GetItemState( Gadget, i ) & #PB_Tree_Checked )
      Debug ""+state +" "+ flag$
      Flag( Object, Flag, state )
   EndProcedure
   
   Procedure events_widgets()
      Protected Flag, Type, flag$
      
      Select WidgetEvent( )
         Case #__event_Free
            Debug "    do free - [" + EventWidget( )\class +"]"
            ProcedureReturn #True
            
         Case #__event_Change
            If *g_TYPE = EventWidget( )
               If *g_OBJECT
                  Free( @*g_OBJECT )
               EndIf
               
               *g_OBJECT = widget_create(Root(), GetItemText( *g_TYPE, GetState( *g_TYPE)), 100, 100, 250, 200, Text, 0,0,0, #__flag_Textmultiline) 
               
               Define Type = GetType(*g_OBJECT)
               Define Flag = Flag(*g_OBJECT)
               Define type$ = ClassFromType(Type)
               Define flag$ = MakeString( Flag, type$)
               ; Define flag$ = GetCheckedText(*g_FLAG)
               ; Define Flag = MakeValue( flag$ )
               Debug "make["+flag$+"] "+ Flag +" "+ type$
;                If GetState(*g_FLAG)
;                   SetFlag( *g_OBJECT, Flag )
;                EndIf
               SetCheckedText(*g_FLAG, flag$ )
                  
            EndIf
            
         Case #__event_LeftClick
            If *g_FLAG = EventWidget( )  
               Define flag$ = GetCheckedText(*g_FLAG)
               Define Flag = MakeValue( flag$ )
               Debug "checked["+flag$+"] "+ Flag
               If GetState(*g_FLAG)
                  SetFlag( *g_OBJECT, Flag )
               EndIf
            EndIf
            
      EndSelect
      
   EndProcedure
   
   If Open( 0, 0, 0, Width+205, Height+30, "flag", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      *g_TYPE = Widget::ListView(Width, 10, 195, 250) 
      For i=0 To 33
         AddItem(*g_TYPE, -1, ClassFromType(i))
      Next
      SetState(*g_TYPE, 1)
      
      *g_FLAG = Widget::Tree(Width, 270, 195, 150, #__flag_optionboxes|#__flag_nobuttons|#__flag_nolines) 
      AddItem(*g_FLAG, -1, "FLAG")
      AddItem(*g_FLAG, -1, "#__flag_Borderless", -1,1)
      AddItem(*g_FLAG, -1, "#__flag_BorderFlat", -1,1)
      AddItem(*g_FLAG, -1, "#__flag_BorderSingle", -1,1)
      AddItem(*g_FLAG, -1, "#__flag_BorderRaised", -1,1)
      AddItem(*g_FLAG, -1, "#__flag_BorderDouble", -1,1)
      
      ;Bind( *g_TYPE, @events_widgets( ), #__event_Change)
      
      WaitClose( @events_widgets( ))
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.21 - C Backend (MacOS X - x64)
; CursorPosition = 278
; FirstLine = 250
; Folding = ------
; EnableXP
; DPIAware