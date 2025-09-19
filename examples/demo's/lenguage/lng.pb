XIncludeFile "../../../widgets.pbi"
XIncludeFile "../../../include/lng.pbi"

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   
   UseWidgets( )
   
   Procedure InitLng( Path.s )
      Protected texte$
      ; Открывает файл настроек
      OpenPreferences( Path )
      
      ; Исследует группы
      ExaminePreferenceGroups()
      ; Для каждой группы
      While NextPreferenceGroup()
         texte$ = texte$ + PreferenceGroupName() + #LF$ ; её имя
                                                        ; Исследует ключи для текущей группы
         ExaminePreferenceKeys()
         ; Для каждого ключа
         While  NextPreferenceKey()
            texte$ = texte$ + PreferenceKeyName() + " = " + PreferenceKeyValue() + #LF$ ; его название и его данные
         Wend
         texte$ = texte$ +  #LF$
      Wend
      
      ; Отображение всех групп и всех ключей с данными
      MessageRequester("test.pref", texte$)
      
      ; Закрывает файл настроек
      ClosePreferences()
   EndProcedure

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
   
   Enumeration lenguage
      #ENG
      #RUS
      #FRENCH
   EndEnumeration
   
   Enumeration lng
      #lng_YES
      #lng_NO
      #lng_CANCEL
      #lng_NEW
      #lng_OPEN
      #lng_SAVE
   EndEnumeration
   
   ; lenguage               ;eng = 0    ;rus = 1          ; french = 2         ; german = 3
   AddLng( #lng_NEW,        "New        |Новый            |Nouveau             |Neu" )
   AddLng( #lng_OPEN,       "Open       |Открыть          |Ouvrir              |Öffnen" )
   AddLng( #lng_SAVE,       "Save       |Сохранить        |Sauvegarder         |Speichern" )
   AddLng( #lng_YES,        "Yes        |Да               |Oui                 |Ja" )
   AddLng( #lng_NO,         "No         |Нет              |Non                 |Nein" )
   AddLng( #lng_CANCEL,     "Cancel     |Отмена           |Annuler             |Abbrechen" )
   
   InitLng("lng.catalog")
   
   Procedure ChangeLng( Lng_TYPE )
      SetText( BUTTON_YES, Lng( Lng_TYPE, #lng_YES) )
      SetText( BUTTON_NO, Lng( Lng_TYPE, #lng_NO) )
      SetText( BUTTON_CANCEL, Lng( Lng_TYPE, #lng_CANCEL) )
      
      SetBarItemText( *ToolBar, #tb_New, Lng( Lng_TYPE, #lng_NEW) )
      SetBarItemText( *ToolBar, #tb_Open, Lng( Lng_TYPE, #lng_OPEN) )
      SetBarItemText( *ToolBar, #tb_Save, Lng( Lng_TYPE, #lng_SAVE) )
      
      Disable( BUTTON_ENG, Bool(Lng_TYPE=#ENG) )
      Disable( BUTTON_RUS, Bool(Lng_TYPE=#RUS) )
      Disable( BUTTON_FRENCH, Bool(Lng_TYPE=#FRENCH) )
   EndProcedure
   
   Procedure WINDOW_DEMO_Events( )
      Select EventWidget( )
         Case BUTTON_ENG
            ChangeLng( #ENG )
            
         Case BUTTON_RUS
            ChangeLng( #RUS )
            
         Case BUTTON_FRENCH
            ChangeLng( #FRENCH )
            
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
      ChangeLng( #ENG ); #RUS )
      
      ;
      Bind( *toolbar, @WINDOW_DEMO_ToolBarEvents( ) )
      Bind( #PB_All, @WINDOW_DEMO_Events( ), #__event_LeftClick )
   EndProcedure
   
   Open_WINDOW_DEMO( )
   
   WaitClose( )
   End
CompilerEndIf


; IDE Options = PureBasic 6.20 (Windows - x64)
; CursorPosition = 15
; Folding = --
; EnableXP
; DPIAware