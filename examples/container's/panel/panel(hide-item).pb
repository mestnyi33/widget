IncludePath "../../../"
XIncludeFile "widgets.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseLib(Widget)
  
  Global *c, *s
  Global *butt1, *butt2
  Global ._s_widget *w,*w1,*w2 ;
  
  Procedure HideItem( *this._s_widget, item.l, state.b )
    If *this\type = #__type_panel
      If *this\tab
        SelectElement( *this\tab\widget\bar\_s( ), item )
        *this\tab\widget\bar\_s( )\hide = state
        *this\state\repaint = #True
        PostCanvasRepaint(*this) ;
      EndIf
    EndIf
  EndProcedure
  
  
  OpenWindow(3, 0, 0, 455, 405, "hide/show widgets", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    Open(3)
    
    ;Button(10,5,50,35, "butt")
    
    *w=Panel     (8, 8, 356, 203)
    AddItem (*w, -1, "Панель 1")
    Button(5, 5, 80, 22,"кнопка 1")
    
    Procedure events_butt()
    	Select EventWidget( )
    		Case *butt1	
    			HideItem(*w, 2, 1)
    
    		Case *butt2	
    			HideItem(*w, 2, 0)

    	EndSelect
    EndProcedure
    AddItem (*w, -1,"Панель 2")
    *butt1 = Button(10, 15, 80, 24,"hide item3")
    *butt2 = Button(95, 15, 80, 24,"show item3")
    Bind(*butt1, @events_butt(), #PB_EventType_LeftClick)
    Bind(*butt2, @events_butt(), #PB_EventType_LeftClick)
    
    AddItem (*w, -1,"Панель 3")
    Button(10, 15, 80, 24,"Кнопка 4")
    Button(95, 15, 80, 24,"Кнопка 5")
    Button(180, 15, 80, 24,"Кнопка 6")
    AddItem (*w, -1,"Панель 4")
    CloseList()
    
    SetState(*w,1)
    HideItem(*w, 2, 1)
    ; HideItem(*w, 1, 0)
    
    WaitClose( )
    
     
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 17
; FirstLine = 13
; Folding = --
; EnableXP