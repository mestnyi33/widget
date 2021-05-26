IncludePath "../../../"
XIncludeFile "widgets.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseLib(Widget)
  
  Global *c, *s
  Global ._s_widget *w,*w1,*w2 ;
  
  Procedure HideItem( *this._s_widget, item.l, state.b )
    If *this\type = #__type_panel
      If *this\tab
        SelectElement( *this\tab\widget\bar\_s( ), item )
        *this\tab\widget\bar\_s( )\hide = state
        *this\tab\widget\bar\change_tab_items = #True
      EndIf
    EndIf
  EndProcedure
  
  
  If OpenWindow(3, 0, 0, 455, 405, "hide/show widgets", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    Open(3)
    
    ;Button(10,5,50,35, "butt")
    
    *w=Panel     (8, 8, 356, 203)
    AddItem (*w, -1, "Панель 1")
    Button(5, 5, 80, 22,"кнопка 1")
    
    AddItem (*w, -1,"Панель 2")
    Button(10, 15, 80, 24,"Кнопка 2")
    Button(95, 15, 80, 24,"Кнопка 3")
    
    AddItem (*w, -1,"Панель 3")
    Button(10, 15, 80, 24,"Кнопка 4")
    Button(95, 15, 80, 24,"Кнопка 5")
    Button(180, 15, 80, 24,"Кнопка 6")
    CloseList()
    
    HideItem(*w, 1, 1)
    ; HideItem(*w, 1, 0)
    
    WaitClose( )
    
  EndIf   
CompilerEndIf
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = -
; EnableXP