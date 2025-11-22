DeclareModule lng
   Global NewMap Lng_MAP.s( )
   
   Enumeration lng
      #ENG
      #RUS
      #FRENCH
      #GERMAN
   EndEnumeration
   
   Macro GetLng( _TYPE_, _KEY_ )
      Lng_MAP( Str(_TYPE_)+"_"+_KEY_ )
   EndMacro
   
   Macro SetLng( _TYPE_, _KEY_, _VALUE_ )
      ; Debug ""+_TYPE_  +" "+  _KEY_  +" "+ _VALUE_
      GetLng( _TYPE_, LCase( _KEY_ ) ) = _VALUE_
   EndMacro
   
   Declare.s LngKey( i )
   Declare.s Lng( key.s )
   Declare.s AddLng( key.s, lng.s )
   Declare   Initlng( lng.s = "" )
   Declare   LoadLng( file.s )
   Declare   ChangeLng( Type )
EndDeclareModule

Module lng
   Global lng_STRING.s
   Global lng_TYPE = #PB_Default
   
   Procedure ChangeLng( Type )
      If lng_TYPE <> Type
         lng_TYPE = Type
         ProcedureReturn #True
      EndIf
   EndProcedure
   
   Procedure.s AddLng( key.s, lng.s )
      Protected i, count
      count = CountString( lng, "|")
      key.s = LCase( key.s )
      For i = 1 To count
         SetLng( i, key.s, Trim( StringField( lng, i, "|" )))
      Next
   EndProcedure
   
   Procedure.s LngKey( i )
      If lng_STRING
         ProcedureReturn Trim( StringField( lng_STRING, 1+i, "|" ))
      EndIf
   EndProcedure
   
   Procedure LoadLng( file.s )
      Protected text$, g, i, keys.s, key.s
      
      If OpenPreferences(file)
         If ExaminePreferenceGroups()
            ; get lng keys
            NextPreferenceGroup()
            ExaminePreferenceKeys()
            While NextPreferenceKey()                      
               lng_STRING.s = lng_STRING.s + Trim(Trim(PreferenceKeyName(), Chr(34))) +"|" 
            Wend
            lng_STRING.s = Trim(lng_STRING.s, "|")
            
            g = 0
            While NextPreferenceGroup()
               g + 1
               If ExaminePreferenceKeys()
                  i = 0
                  While NextPreferenceKey()                      
                     key.s = Trim( StringField( lng_STRING.s, 1+i, "|" ))
                     If FindString( lng_STRING, key.s )
                        SetLng( g, key.s, Trim(Trim(PreferenceKeyName(), Chr(34))) )
                     EndIf
                     i + 1
                  Wend
               EndIf
            Wend
            ; Debug MapSize(lng_map())
         EndIf
         
         ; Close the preference file
         ClosePreferences()  
      EndIf
      
      ProcedureReturn @lng_STRING
   EndProcedure
   
   Procedure Initlng( lng.s = "" )
      If lng.s
         lng_STRING = lng.s
         ProcedureReturn @lng_STRING
      EndIf
   EndProcedure
   
   Procedure.s Lng( key.s )
      Protected lng.s = GetLng( lng_TYPE, LCase( key.s ))
      If lng.s
         ProcedureReturn lng.s
      Else
         ProcedureReturn key.s
      EndIf
   EndProcedure
   
   ;
   AddLng( "Yes"    ,"Да     |Oui     |Ja" )
   AddLng( "No"     ,"Нет    |Non     |Nein" )
   AddLng( "Cancel" ,"Отмена |Annuler |Abbrechen" )
EndModule

;-
CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   
   XIncludeFile "../widgets.pbi"
   
   UseWidgets( )
   
   ;
   Global WINDOW_DEMO = - 1
   Global *ToolBar = - 1
   
   Global BUTTON_YES = - 1
   Global BUTTON_NO = - 1
   Global BUTTON_CANCEL = - 1
   Global BUTTON_ENG = - 1
   Global BUTTON_RUS = - 1
   Global BUTTON_FRENCH = - 1
   
   Enumeration 1
      #tb_New
      #tb_Open
      #tb_Save
   EndEnumeration
   
   
   InitLng( "New|Open|Save" )
   
   ; 1 example
   ;       ;eng = 0   ;rus = 1   ;french = 2  ;german = 3
   AddLng( LngKey(0), "Новый     |Nouveau     |Neu" )
   AddLng( LngKey(1), "Открыть   |Ouvrir      |Öffnen" )
   AddLng( LngKey(2), "Сохранить |Sauvegarder |Speichern" )
   
   ;    ; 2 example
   ;    ;       ;eng = 0    ;rus = 1           ;french = 2          ;german = 3
   ;    AddLng( "New"       ,"Новый            |Nouveau             |Neu" )
   ;    AddLng( "Open"      ,"Открыть          |Ouvrir              |Öffnen" )
   ;    AddLng( "Save"      ,"Сохранить        |Sauvegarder         |Speichern" )    
   
   ;    ; 3 example 
   ;    LoadLng( "C:\Users\user\Documents\GitHub\widget\IDE\lng.ini" )
   
   Procedure WINDOW_DEMO_ChangeLng( Lng_TYPE )
      If ChangeLng( Lng_TYPE )
         SetText( BUTTON_YES, Lng( "Yes" ))
         SetText( BUTTON_NO, Lng( "No" ))
         SetText( BUTTON_CANCEL, Lng( "Cancel" ))
         
         SetBarItemText( *ToolBar, #tb_New, Lng( LngKey(0) ))
         SetBarItemText( *ToolBar, #tb_Open, Lng( LngKey(1) ))
         SetBarItemText( *ToolBar, #tb_Save, Lng( LngKey(2) ))
         
         Disable( BUTTON_ENG, Bool(Lng_TYPE=#ENG) )
         Disable( BUTTON_RUS, Bool(Lng_TYPE=#RUS) )
         Disable( BUTTON_FRENCH, Bool(Lng_TYPE=#FRENCH) )
      EndIf
   EndProcedure
   
   Procedure WINDOW_DEMO_Events( )
      Select EventWidget( )
         Case BUTTON_ENG
            WINDOW_DEMO_ChangeLng( #ENG )
            
         Case BUTTON_RUS
            WINDOW_DEMO_ChangeLng( #RUS )
            
         Case BUTTON_FRENCH
            WINDOW_DEMO_ChangeLng( #FRENCH )
            
      EndSelect
   EndProcedure
   
   Procedure WINDOW_DEMO_ToolBarEvents( )
      Debug ""+WidgetEventItem( ) +" - EVENT BAR BUTTON"
   EndProcedure
   
   
   Procedure Open_WINDOW_DEMO( )
      WINDOW_DEMO = Open( #PB_Any, 7, 7, 386, 176, "Demo lenguage change", #PB_Window_SystemMenu | #PB_Window_ScreenCentered  )
      BUTTON_YES = Button( 7, 7, 120, 113, "" )
      BUTTON_NO = Button( 133, 7, 120, 113, "" )
      BUTTON_CANCEL = Button( 259, 7, 120, 113, "" )
      BUTTON_ENG = Button( 7, 126, 120, 43, "eng" )
      BUTTON_RUS = Button( 133, 126, 120, 43, "rus" )
      BUTTON_FRENCH = Button( 259, 126, 120, 43, "french" )
      
      ;
      *ToolBar = CreateBar( WINDOW_DEMO, #PB_ToolBar_Small|#PB_ToolBar_Text)
      If *toolbar
         SetColor( *toolbar, #PB_Gadget_BackColor, $FFDFDFDF )
         BarSeparator( )
         BarButton(#tb_New, -1, #PB_ToolBar_Normal, "" )
         BarSeparator( )
         BarButton(#tb_Save, -1, #PB_ToolBar_Normal, "" )
         BarSeparator( )
         BarButton(#tb_Open, -1, #PB_ToolBar_Normal, "" )
         BarSeparator( )
      EndIf
      
      ; FIXME
      DisableBarButton( *toolbar, #tb_Save, #True ) 
      ; Bug
      SetBarItemText( *toolbar, #tb_Save, "Save as ..." )
      
      ; TODO
      ResizeWindow(GetCanvasWindow(GetRoot(*ToolBar) ), #PB_Ignore, #PB_Ignore, #PB_Ignore, 176+25)
      ResizeGadget(GetCanvasGadget(GetRoot(*ToolBar) ), #PB_Ignore, #PB_Ignore, #PB_Ignore, 176+25)
      ;Resize(GetRoot(*ToolBar) , #PB_Ignore, #PB_Ignore, #PB_Ignore, 386+40)
      
      ;
      WINDOW_DEMO_ChangeLng( #ENG ); #RUS )
      
      ;
      Bind( *toolbar, @WINDOW_DEMO_ToolBarEvents( ) )
      Bind( #PB_All, @WINDOW_DEMO_Events( ), #__event_LeftClick )
   EndProcedure
   
   Open_WINDOW_DEMO( )
   
   WaitClose( )
   End
CompilerEndIf


; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 24
; FirstLine = 9
; Folding = -----
; EnableXP
; DPIAware