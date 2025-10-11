XIncludeFile "../../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
   Global *mdi, *menu, *tmenu
   Global submenu, firstmenuitem = 2
   
   Procedure MDI_AddItem( *this._s_WIDGET, item, Text.s, img = - 1 )
      Protected._s_WIDGET *menu
      Protected._s_ROWS *item, *tab
      *menu = *this\root\menubar
      
      ForEach *menu\__tabs( )
         If ListIndex( *menu\__tabs( ) ) = submenu
            *tab = *menu\__tabs( )
            *item = AddItem( *tab\popupbar, item+firstmenuitem-1, Text, img ) 
            *item\sublevel = *tab\sublevel + 1
            *item\data = AddItem( *this, item, Text )
            *tab\childrens + 1
         EndIf
      Next
   EndProcedure
   
   Procedure MDI_SetState( *this._s_WIDGET, state )
      If state = #PB_MDI_Next
         state = #PB_List_After
      EndIf
      If state = #PB_MDI_Previous
         state = #PB_List_Before
      EndIf
      
      Protected._s_WIDGET *menu, *last, *child
      Protected._s_ROWS *item, *tab
      *menu = *this\root\menubar
      *tab = *menu\__tabs( )
      *last = *this\LastWidget( )
;       Debug *last\text\string
;       
      ForEach *Tab\popupbar\__tabs( )
         *child = *Tab\popupbar\__tabs( )\data
         ; Debug *child\text\string
         ;SetPosition( *Tab\popupbar\__tabs( )\data, state, *last )
         
         ;   MoveElement( widgets( ), #PB_List_After, *last\address )
         
      Next
   EndProcedure
   
   Procedure BarEvents()
      Select EventBar()
         Case 0, 2
            MDI_SetState(*mdi, #PB_MDI_Next)
         Case 1, 3
            MDI_SetState(*mdi, #PB_MDI_Previous)
      EndSelect
      
      Debug "EventBar "+ EventBar()
   EndProcedure
   
   If Open(0, 0, 0, 800, 600, "MDIGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_SizeGadget | #PB_Window_MaximizeGadget)
      *menu = CreateBar(root())
      If *menu
         *tmenu = BarTitle("MDI windows menu")
         
         AddKeyboardShortcut(0, #PB_Shortcut_Control | #PB_Shortcut_Tab, 1)
         AddKeyboardShortcut(0, #PB_Shortcut_Control | #PB_Shortcut_Shift | #PB_Shortcut_Tab, 0)
         Bind( *menu, @BarEvents() )
      EndIf
      
      ; *mdi = MDI(0, 50, 800, 500)
      *mdi = MDI(0, 0, 0, 0, #PB_MDI_AutoSize|#__flag_BorderDouble) 
      SetBackColor( *mdi, $D3D3D3 )
      MDI_AddItem(*mdi, 1, "child1")
      MDI_AddItem(*mdi, 2, "child2")
      MDI_AddItem(*mdi, 3, "child3")
      MDI_AddItem(*mdi, 4, "child4")
      UseGadgetList(WindowID(0))
      
      Repeat : Until WaitWindowEvent(1) = #PB_Event_CloseWindow
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.20 (Windows - x64)
; CursorPosition = 46
; FirstLine = 14
; Folding = --
; EnableXP
; DPIAware