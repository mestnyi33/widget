XIncludeFile "../../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
   Procedure SetBarText( *this._s_WIDGET, _index_, _text_.s )
      If *this\type = #__type_menubar
         ForEach *this\__tabs( )
            ; Debug ""+*this\__tabs( )\text\string +" "+ *this\__tabs( )\tindex +" "+ *this\__tabs( )\_menubar
            ForEach *this\__tabs( )\_menubar\__tabs( )
               If *this\__tabs( )\_menubar\__tabs( )\tindex = _index_
                  ; Debug ""+*this\__tabs( )\_menubar\__tabs( )\text\string +" "+ *this\__tabs( )\_menubar\__tabs( )\tindex +" "+ *this\__tabs( )\_menubar\__tabs( )\_menubar
                  SetItemText( *this\__tabs( )\_menubar, ListIndex(*this\__tabs( )\_menubar\__tabs( )), _text_.s )
                  Break 2
               EndIf
            Next
         Next
      EndIf
   EndProcedure
   
   If Open(0, 200, 200, 300, 200, "Пример SetMenuTitleText")
      ButtonGadget(0, 70, 110, 200, 30, "Изменить текст заголовка Проект")
      If CreateMenu(0, WindowID(0))
         MenuTitle("Проект1")
         MenuItem(1, "Открыть")
         MenuItem(2, "Закрыть")
         MenuTitle("Проект2")
         MenuItem(1, "Открыть")
         MenuItem(3, "Закрыть")
      EndIf
      
      Define *g._s_WIDGET = CreateBar(root( ))
      If *g
         Define *t1=BarTitle("Проект1")
         BarItem(1, "Открыть")
         BarItem(2, "Закрыть")
         Define *t2=BarTitle("Проект2")
         BarItem(1, "Открыть")
         BarItem(3, "Закрыть")
      EndIf
      
      Define Event
      Repeat
         Event = WaitWindowEvent()
         If Event = #PB_Event_Gadget
            Select EventGadget()
               Case 0
                  SetMenuTitleText(0, 1, "Файл") 
                  SetMenuItemText(0, 1, "change")
                  SetMenuItemText(0, 3, "change")
                  
                  SetBarTitleText(*g, 1, "Файл") 
                  SetBarItemText(*g, 1, "change") 
                  SetBarItemText(*g, 3, "change")
                  
;                   SetBarText(*g, 1, "change") 
;                   SetBarText(*g, 3, "change")
;                   SetBarItemText(*t1, 1, "change") 
;                   SetBarItemText(*t2, 3, "change")
                  ReDraw( GetRoot(*g) )
            EndSelect
         EndIf
      Until Event = #PB_Event_CloseWindow
   EndIf
   
CompilerEndIf
; IDE Options = PureBasic 6.20 (Windows - x64)
; CursorPosition = 55
; FirstLine = 28
; Folding = --
; EnableXP
; DPIAware