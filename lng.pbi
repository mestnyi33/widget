Global NewMap Lng_MAP.s( )

Macro AddLng( _TYPE_, _VALUE_ )
   Lng_MAP( Str(_TYPE_)+"_"+Str(_VALUE_) )
EndMacro

Macro Lng( _TYPE_, _VALUE_ )
   Lng_MAP( Str(_TYPE_)+"_"+Str(_VALUE_) )
EndMacro

;
Enumeration 
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

; AddLng(#ENG, #lng_YES) = "Yes"
; AddLng(#ENG, #lng_NO) = "No"
; AddLng(#ENG, #lng_CANCEL) = "Cancel"
; 
; AddLng(#RUS, #lng_YES) = "Да"
; AddLng(#RUS, #lng_NO) = "Нет"
; AddLng(#RUS, #lng_CANCEL) = "Отмена"
; 
; AddLng(#FRENCH, #lng_YES) = "Oui"
; AddLng(#FRENCH, #lng_NO) = "Non"
; AddLng(#FRENCH, #lng_CANCEL) = "Annuler"


Procedure InitLng( word.s )
   word = RemoveString( word, "#lng_")
   Protected str.s
   Protected i, count = CountString( word, "|") + (1)
   For i = 1 To count
      str.s = LCase(Trim( StringField( word, i, "|" )))
      If str = "new"
         AddLng(#ENG, #lng_NEW) = "New"
         AddLng(#RUS, #lng_NEW) = "Новый"
         AddLng(#FRENCH, #lng_NEW) = "Nouveau" 
      EndIf
      If str = "open"
         AddLng(#ENG, #lng_OPEN) = "Open"
         AddLng(#RUS, #lng_OPEN) = "Открыть"
         AddLng(#FRENCH, #lng_OPEN) = "Ouvrir" 
      EndIf
      If str = "save"
         AddLng(#ENG, #lng_SAVE) = "Save"
         AddLng(#RUS, #lng_SAVE) = "Сохранить"
         AddLng(#FRENCH, #lng_SAVE) = "Sauvegarder" 
      EndIf
      If str = "yes"
         AddLng(#ENG, #lng_YES) = "Yes"
         AddLng(#RUS, #lng_YES) = "Да"
         AddLng(#FRENCH, #lng_YES) = "Oui"
      EndIf
      If str = "no"
         AddLng(#ENG, #lng_NO) = "No"
         AddLng(#RUS, #lng_NO) = "Нет"
         AddLng(#FRENCH, #lng_NO) = "Non"
      EndIf
      If str = "cancel"
         AddLng(#ENG, #lng_CANCEL) = "Cancel"
         AddLng(#RUS, #lng_CANCEL) = "Отмена"
         AddLng(#FRENCH, #lng_CANCEL) = "Annuler"
      EndIf
      ; Debug str
   Next
EndProcedure


CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   
   XIncludeFile "widgets.pbi"
   
   UseWidgets( )
   
   Enumeration 1
      #tb_New
      #tb_Open
      #tb_Save
   EndEnumeration
   
   Global WINDOW_DEMO = - 1
   Global *ToolBar = - 1
   
   Global BUTTON_YES = - 1
   Global BUTTON_NO = - 1
   Global BUTTON_CANCEL = - 1
   Global BUTTON_ENG = - 1
   Global BUTTON_RUS = - 1
   Global BUTTON_FRENCH = - 1
   
   InitLng( "yes | no | cancel | new | open | save" )
   ;InitLng( "#lng_yes | #lng_no | #lng_cancel" )
   
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
      
      
      *ToolBar = ToolBar( WINDOW_DEMO, #PB_ToolBar_Small|#PB_ToolBar_Text)
      ResizeWindow(GetCanvasWindow(GetRoot(*ToolBar) ), #PB_Ignore, #PB_Ignore, #PB_Ignore, 176+25)
      ResizeGadget(GetCanvasGadget(GetRoot(*ToolBar) ), #PB_Ignore, #PB_Ignore, #PB_Ignore, 176+25)
      ;Resize(GetRoot(*ToolBar) , #PB_Ignore, #PB_Ignore, #PB_Ignore, 386+40)
      
      If *toolbar
         SetColor( *toolbar, #PB_Gadget_BackColor, $FFDFDFDF )
         BarSeparator( )
         BarButton(#tb_New, -1, #PB_ToolBar_Normal, "" )
         BarSeparator( )
         BarButton(#tb_Open, -1, #PB_ToolBar_Normal, "" )
         BarSeparator( )
         BarButton(#tb_Save, -1, #PB_ToolBar_Normal, "" )
         BarSeparator( )
      EndIf
      
      ; BUG
      DisableBarButton( *toolbar, #tb_Open, #True ) 
      ; SetBarItemText( *toolbar, #tb_Save, "Save as ..." )
      
      ChangeLng( #RUS )
      
      Bind( *toolbar, @WINDOW_DEMO_ToolBarEvents( ) )
      Bind( #PB_All, @WINDOW_DEMO_Events( ), #__event_LeftClick )
   EndProcedure
   
   Open_WINDOW_DEMO( )
   
   WaitClose( )
   End
CompilerEndIf


; IDE Options = PureBasic 6.20 (Windows - x64)
; CursorPosition = 162
; FirstLine = 138
; Folding = ---
; EnableXP
; DPIAware