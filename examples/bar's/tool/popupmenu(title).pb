XIncludeFile "../../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
   Global g,*g._s_WIDGET
   
   Procedure SetBarText( *this._s_WIDGET, _index_, _text_.s )
      If *this\type = #__type_menubar
         ForEach *this\__tabs( )
            ; Debug ""+*this\__tabs( )\text\string +" "+ *this\__tabs( )\tindex +" "+ *this\__tabs( )\popupbar
            ForEach *this\__tabs( )\popupbar\__tabs( )
               If *this\__tabs( )\popupbar\__tabs( )\tindex = _index_
                  ; Debug ""+*this\__tabs( )\popupbar\__tabs( )\text\string +" "+ *this\__tabs( )\popupbar\__tabs( )\tindex +" "+ *this\__tabs( )\_menubar\__tabs( )\_menubar
                  SetItemText( *this\__tabs( )\popupbar, ListIndex(*this\__tabs( )\popupbar\__tabs( )), _text_.s )
                  Break 2
               EndIf
            Next
         Next
      EndIf
   EndProcedure
   
   If Open(0, 200, 200, 300, 200, "Изменить текст заголовка Проект2")
      g = CreatePopupMenu( #PB_Any )
      If g
         MenuTitle("Проект1")
         MenuItem(1, "Открыть")
         MenuItem(2, "Закрыть")
         MenuTitle("Проект2")
         MenuItem(1, "Открыть")
         MenuItem(3, "Закрыть")
      EndIf
      
      *g = CreatePopupBar( )
      If *g
         Define *t1=BarTitle("Проект1")
         BarItem(1, "Открыть")
         BarItem(2, "Закрыть")
         Define *t2=BarTitle("Проект2")
         BarItem(1, "Открыть")
         BarItem(3, "Закрыть")
      EndIf
      
      SetMenuTitleText(g, 1, "Проект2 (change)") 
      SetMenuItemText(g, 1, "Открыть (change)")
      SetMenuItemText(g, 3, "Закрыть (change)")
      
      SetBarTitleText(*g, 1, "Проект2 (change)") 
      SetBarItemText(*g, 1, "Открыть (change)") 
      SetBarItemText(*g, 3, "Закрыть (change)")
;       SetBarText(*g, 1, "Открыть (change)") 
;       SetBarText(*g, 3, "Закрыть (change)")

      ButtonGadget(0, 70, 110, 200, 30, "popup menu")
      DisplayPopupBar( *g, Root( ), GadgetX(0), GadgetY(0)+GadgetHeight(0))
      DisplayPopupMenu( g, WindowID(0), DesktopScaledX(GadgetX(0, #PB_Gadget_ScreenCoordinate)), DesktopScaledY(GadgetY(0, #PB_Gadget_ScreenCoordinate))-100)
      
      
      Define Event
      Repeat
         Event = WaitWindowEvent()
         If Event = #PB_Event_Gadget
            Select EventGadget()
               Case 0
           EndSelect
         EndIf
      Until Event = #PB_Event_CloseWindow
   EndIf
   
CompilerEndIf
; IDE Options = PureBasic 6.21 - C Backend (MacOS X - x64)
; CursorPosition = 65
; FirstLine = 36
; Folding = --
; EnableXP
; DPIAware