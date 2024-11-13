XIncludeFile "../../../widgets.pbi"

EnableExplicit
UseWidgets( )

Global  *list1, *list2, *list3
Global i, drop, source, appQuit, dropText$, selectedIndex, selectedText$

Procedure event_widget()
  
  Select WidgetEvent()
    Case #__event_DragStart      
      Debug "event( DRAGSTART )"
      
      Select EventWidget()         
        Case *list1, *list2, *list3       
          source = EventWidget()
          selectedIndex = GetState(EventWidget())           
          selectedText$ = GetItemText(EventWidget(), selectedIndex)
          DDragText(selectedText$)                                           
          
      EndSelect
      
    Case #__event_Drop
      Debug "event( DROP )"
      drop = EventWidget()
      
      If drop <> source
        dropText$ = DDropText()
        
        For i = 0 To CountItems(drop)-1
          If GetItemText(drop, i) = dropText$
            SetActive(drop)
            SetState(drop, i)           
            Break             
          EndIf
        Next i
      EndIf
      
      source = 0
  EndSelect
EndProcedure

Define wFlags = #PB_Window_SystemMenu | #PB_Window_ScreenCentered
Open( 0, #PB_Ignore, #PB_Ignore, 600, 400, "Drag & Drop Text Matching", wFlags )

Text(20, 10, 150, 30, "Personal Records")
Text(220, 10, 150, 30, "Bank Statement")
Text(420, 10, 150, 30, "Personal Records")

*list1 = ListView(10, 40, 180, 350)
AddItem(*list1, -1, "31DEC20#789")
AddItem(*list1, -1, "02JAN21#123")
AddItem(*list1, -1, "15JAN21#666")
AddItem(*list1, -1, "19JAN21#456")
AddItem(*list1, -1, "22JAN21#789")
AddItem(*list1, -1, "28JAN21#123")
AddItem(*list1, -1, "30JAN21#999")

*list2 = ListView(210, 40, 180, 350)
AddItem(*list2, -1, "31DEC20#789")
AddItem(*list2, -1, "19JAN21#456")
AddItem(*list2, -1, "28JAN21#123")

*list3 = ListView(410, 40, 180, 350)
AddItem(*list3, -1, "31DEC20#789")
AddItem(*list3, -1, "02JAN21#123")
AddItem(*list3, -1, "15JAN21#666")
AddItem(*list3, -1, "19JAN21#456")
AddItem(*list3, -1, "22JAN21#789")
AddItem(*list3, -1, "28JAN21#123")
AddItem(*list3, -1, "30JAN21#999")

EnableDrop(*list1, #PB_Drop_Text, #PB_Drag_Copy)
EnableDrop(*list2, #PB_Drop_Text, #PB_Drag_Copy)
;EnableDrop(*list3, #PB_Drop_Text, #PB_Drag_Copy)

Bind(*list1, @event_widget( ), #__event_DragStart)
Bind(*list1, @event_widget( ), #__event_Drop)

Bind(*list2, @event_widget( ), #__event_DragStart)
Bind(*list2, @event_widget( ), #__event_Drop)

Bind(*list3, @event_widget( ), #__event_DragStart)
Bind(*list3, @event_widget( ), #__event_Drop)

WaitClose()
; Repeat
;   
;   Select WaitWindowEvent()   
;       
;     Case #PB_Event_CloseWindow
;       appQuit = #True       
;       
;   EndSelect 
;   
; Until appQuit
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 6
; FirstLine = 3
; Folding = -
; EnableXP
; DPIAware