IncludePath "../../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
   Global *this._s_widget, i, w_type, w_flag, w_flag2
   Global  vert=100, horiz=100, Width=400, Height=400
   Global cr.s = #LF$, Text.s = "Vertical & Horizontal" + cr + "   Centered   Text in   " + cr + "Multiline StringGadget"
   
   Procedure widget_create( *parent._s_widget, type$, X.l,Y.l, Width.l=#PB_Ignore, Height.l=#PB_Ignore, text$="", Param1=0, Param2=0, Param3=0, flag.q = 0 )
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
            If Type( *parent ) = #__Type_MDI
               *new = AddItem( *parent, #PB_Any, text$, - 1, flag | #PB_Window_NoActivate )
               Resize( *new, X, Y, Width, Height )
            Else
               flag | #PB_Window_SystemMenu | #PB_Window_MaximizeGadget | #PB_Window_MinimizeGadget | #PB_Window_NoActivate
               *new = Window( X,Y,Width,Height, text$, flag, *parent )
            EndIf
            
         Case "scrollarea"  : *new = ScrollArea( X,Y,Width,Height, Param1, Param2, Param3, flag ) : CloseList( ) ; 1 
         Case "container"   : *new = Container( X,Y,Width,Height, flag ) : CloseList( )
         Case "panel"       : *new = Panel( X,Y,Width,Height, flag ) : CloseList( )
            
         Case "button"      : *new = Button(       X, Y, Width, Height, text$, flag ) 
         Case "string"        : *new = String(       X, Y, Width, Height, text$, flag )
         Case "text"          : *new = Text(         X, Y, Width, Height, text$, flag )
         Case "checkbox"      : *new = CheckBox(     X, Y, Width, Height, text$, flag ) 
            ; Case "web"           : *new = Web(          X, Y, Width, Height, text$, flag )
         Case "explorerlist"  : *new = ExplorerList( X, Y, Width, Height, text$, flag )                                                                           
            ; Case "explorertree"  : *new = ExplorerTree( X, Y, Width, Height, text$, flag )                                                                           
            ; Case "explorercombo" : *new = ExplorerCombo(X, Y, Width, Height, text$, flag )                                                                          
         Case "frame"         : *new = Frame(        X, Y, Width, Height, text$, flag )                                                                                  
            
            ; Case "date"          : *new = Date(         X, Y, Width, Height, text$, Param1, flag )         ; 2            
         Case "hyperlink"     : *new = HyperLink(    X, Y, Width, Height, text$, Param1, flag )                                                          
         Case "listicon"      : *new = ListIcon(     X, Y, Width, Height, text$, Param1, flag )                                                       
            
         Case "scroll"        : *new = Scroll(       X, Y, Width, Height, Param1, Param2, Param3, flag )  ; bar                                                             
            
         Case "progress"      : *new = Progress(     X, Y, Width, Height, Param1, Param2, flag )          ; bar                                                           
         Case "track"         : *new = Track(        X, Y, Width, Height, Param1, Param2, flag )          ; bar                                                                           
         Case "spin"          : *new = Spin(         X, Y, Width, Height, Param1, Param2, flag )                                                                             
         Case "splitter"      : *new = Splitter(     X, Y, Width, Height, Param1, Param2, flag )                ; :Debug ""+Param1 +" "+ Param2 ;                                                          
         Case "mdi"           : *new = MDI(          X, Y, Width, Height, flag )  ;  , Param1, Param2                                                                          
         Case "image"         : *new = Image(        X, Y, Width, Height, Param1, flag )                                                                                                     
         Case "buttonimage"   : *new = ButtonImage(  X, Y, Width, Height, Param1, flag )                                                                                                 
            
            ; Case "calendar"      : *new = Calendar(     X, Y, Width, Height, Param1, flag )                 ; 1                                                 
            
         Case "listview"      : *new = ListView(     X, Y, Width, Height, flag )                                                                                                                       
         Case "combobox"      : *new = ComboBox(     X, Y, Width, Height, flag ) 
         Case "editor"        : *new = Editor(       X, Y, Width, Height, flag )                                                                                                                          
         Case "tree"          : *new = Tree(         X, Y, Width, Height, flag )                                                                                                                            
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
         ;             newtype$ = Class( *new )+"_"+CountType( *new , 2 )
         ;          Else
         ;             newtype$ = Class( *parent )+"_"+CountType( *parent, 2 )+"_"+Class( *new )+"_"+CountType( *new , 2 )
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
               
               If Not flag & #__flag_NoFocus 
                  a_set(*new, #__a_full, (14))
               EndIf
               SetBackgroundColor( *new, $FFECECEC )
               ;
               ;Properties_Updates( *new, "Resize" )
               ;Bind( *new, @widget_events( ) )
            Else
               If Not flag & #__flag_NoFocus 
                  a_set(*new, #__a_full, (10))
               EndIf
               SetBackgroundColor( *new, $FFF1F1F1 )
            EndIf 
            
            ; 
            *new\ChangeColor = 0
         Else
            If Not flag & #__flag_NoFocus 
               a_set(*new, #__a_full)
            EndIf
         EndIf
         
         ;Bind( *new, @widget_events( ), #__event_Resize )
      EndIf
      
      CloseList( ) 
   EndIf
   
   ProcedureReturn *new
EndProcedure

Procedure Add(Text.s)
      ClearItems(w_flag)
      ClearItems(w_flag2)
      
      If Text
         Protected i, sublevel, String.s, count = CountString(Text,"|")
         
         
         For I = 0 To count
            String = Trim(StringField(Text,(I+1),"|"))
            
            Select LCase(Trim(StringField(String,(3),"_")))
               Case "left" : sublevel = 1
               Case "right" : sublevel = 1
               Case "center" : sublevel = 1
               Default
                  sublevel = 0
            EndSelect
            
            AddItem(w_flag, -1, String, -1, sublevel)
            AddItem(w_flag2, -1, String, -1, sublevel)
            
         Next
      EndIf 
   EndProcedure
   
   Procedure Set(Gadget, Object)
      Protected i, state, flag.q
      i = GetState(Gadget)
      flag = MakeConstants( GetItemText( Gadget, i ))
      state = Bool( GetItemState( Gadget, i) & #PB_Tree_Checked )
      
      Flag(Object, flag, state )
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
   
   
   Procedure events_widgets()
      Protected flag, Type, flag$
      
      Select WidgetEvent( )
         Case #__event_Change
            Select EventWidget( )
               Case w_type 
                  If *this
                     Free(*this)
                  EndIf
                  *this = widget_create(root(), GetItemText( w_type, GetState( w_type)), 100, 100, 250, 200, Text, 0,0,0, #PB_Button_Toggle|#__flag_text_multiline) 
                  Debug  ""+GetText( w_type)+" "+GetItemText( w_type, GetState( w_type))
                  If *this
                     flag = Flag(*this)
                     Type = Type(*this)
                  EndIf
               
                  Add( MakeFlagsString( GetState(w_type)))
                  
                  flag$ = MakeConstantsString( ClassFromType(Type), flag)
                  Debug "flag["+Flag$+"]"
                  SetCheckedText(w_flag, flag$ )
                  
                  ;PostReDraw( root() )
                  ;ReDraw( root() )
                  
               Case w_flag
                  Debug "checked["+GetCheckedText(w_flag)+"]"
            EndSelect
            
         ;Case #__event_LeftClick
;             Select EventWidget( )
;                Case w_flag
;                   Set(w_flag, *this)
                  
;             EndSelect
            
;             If flag
;                Flag(*this, flag, GetState(EventWidget( )))
;             EndIf
      EndSelect
      
   EndProcedure
   
   If Open(0, 0, 0, Width+205, Height+30, "flag", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      ;*this = widget::Button(100, 100, 250, 200, Text, #PB_Button_Toggle|#__flag_text_multiline) 
      
      
      w_type = widget::ListView(Width+45, 10, 150, 200) 
      For i=0 To 33
         AddItem(w_type, -1, ClassFromType(i))
      Next
      SetState(w_type, 1)
      
      w_flag2 = widget::ComboBox(Width+45, 215, 150, 25, #__tree_CheckBoxes|#__flag_optionboxes|#__tree_nobuttons|#__tree_nolines) 
      w_flag = widget::Tree(Width+45, 245, 150, 200-25, #__tree_CheckBoxes|#__flag_optionboxes|#__tree_nobuttons|#__tree_nolines) 
      
      
      Bind(#PB_All, @events_widgets())
      
      
      ; WaitClose( )
      Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.20 (Windows - x64)
; CursorPosition = 83
; FirstLine = 65
; Folding = ------
; EnableXP
; DPIAware