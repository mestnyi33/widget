;
;
;
EnableExplicit
Prototype pFunc( )

Structure _s_event_type
  List calllist.i( )
  
EndStructure

Structure _s_event_data
  *widget._s_Widget
  *type
EndStructure

Structure _s_event
  *function.pFunc
  type._s_event_type[100]
  List queue.i( )
EndStructure

Structure _s_Widget
  event._s_event
EndStructure

Global event._s_event_data

Procedure ReEventType(eventtype)
  If eventtype = #PB_All
    eventtype = 0
  EndIf
  If eventtype = #PB_EventType_MouseEnter
    eventtype = 1
  EndIf
  If eventtype = #PB_EventType_MouseLeave
    eventtype = 2
  EndIf
  If eventtype = #PB_EventType_MouseMove
    eventtype = 3
  EndIf
  ProcedureReturn eventtype
EndProcedure

Procedure BindWidgetEvent( *widget._s_Widget, *callback, eventtype )
  If *widget = #PB_All
    ; 4)
  Else
    Protected key = ReEventType( eventtype )
    
    AddElement( *widget\event\type[key]\calllist( ))
    *widget\event\type[key]\calllist( ) = *callback
    *widget\event\function = *callback
  EndIf
EndProcedure

Procedure UnBindWidgetEvent( *widget._s_Widget, *callback, eventtype )
  If *widget = #PB_All
    ; 4)
  Else
    ; 1)
    ; 2)
    ; 3)
  EndIf
EndProcedure

Procedure PostWidgetEvent( *widget._s_Widget, eventtype )
  If *widget = #PB_All
    ; 4)
  Else
    ; 1)
    Protected key = ReEventType( eventtype )
    
    event\widget = *widget
    
    If ListSize(*widget\event\queue( ))
      ForEach *widget\event\queue( )
        event\type = *widget\event\queue( )
Protected key2 = ReEventType( *widget\event\queue( ) )
        
        ForEach *widget\event\type[key2]\calllist( )
          *widget\event\function = *widget\event\type[key2]\calllist( )
          If *widget\event\function( )
            ; 
          EndIf
        Next
        
        ; all events
        ForEach *widget\event\type\calllist( )
          *widget\event\function = *widget\event\type\calllist( )
          If *widget\event\function( )
            ; 
          EndIf
        Next
      Next
      
      ClearList(*widget\event\queue( ))
    EndIf
    
    event\type = eventtype
    
    ForEach *widget\event\type[key]\calllist( )
      *widget\event\function = *widget\event\type[key]\calllist( )
      If *widget\event\function( )
        ; 
      EndIf
    Next
    
    ; all events
    ForEach *widget\event\type\calllist( )
      *widget\event\function = *widget\event\type\calllist( )
      If *widget\event\function( )
        ; 
      EndIf
    Next
    
    event\widget = #Null
    event\type = #PB_All
    
    If *widget\event\function = 0
      AddElement( *widget\event\queue( ))
      *widget\event\queue( ) = eventtype
    EndIf
    
    ; 2)
    ; 3)
  EndIf
EndProcedure

DisableExplicit
Global widget_1._s_Widget
Global widget_2._s_Widget

PostWidgetEvent( widget_1, #PB_EventType_MouseEnter )
PostWidgetEvent( widget_2, #PB_EventType_MouseEnter )

; 1)
Procedure enter_event( )
  Debug #PB_Compiler_Procedure +" "+ event\widget +" "+ event\type
EndProcedure

Procedure leave_event( )
  Debug #PB_Compiler_Procedure +" "+ event\widget +" "+ event\type
EndProcedure

BindWidgetEvent( widget_1, @enter_event(), #PB_EventType_MouseEnter )
BindWidgetEvent( widget_1, @leave_event(), #PB_EventType_MouseLeave )

BindWidgetEvent( widget_2, @enter_event(), #PB_EventType_MouseEnter )
BindWidgetEvent( widget_2, @leave_event(), #PB_EventType_MouseLeave )

; 2)
Procedure el_event( )
  Select event_type
    Case #PB_EventType_MouseEnter  
    Case #PB_EventType_MouseLeave 
  EndSelect
  
  Debug "      "+#PB_Compiler_Procedure +" "+ event\widget +" "+ event\type
EndProcedure

BindWidgetEvent( widget_1, @el_event(), #PB_EventType_MouseEnter )
BindWidgetEvent( widget_1, @el_event(), #PB_EventType_MouseLeave )

BindWidgetEvent( widget_2, @el_event(), #PB_EventType_MouseEnter )
BindWidgetEvent( widget_2, @el_event(), #PB_EventType_MouseLeave )

; 3)
Procedure all_event()
  Select event_type
    Case #PB_EventType_LeftButtonDown  
    Case #PB_EventType_LeftButtonUp   
    Case #PB_EventType_MouseEnter 
    Case #PB_EventType_MouseLeave  
      ; .......  
  EndSelect
  Debug "              "+#PB_Compiler_Procedure +" "+ event\widget +" "+ event\type
EndProcedure

BindWidgetEvent( widget_1, @all_event(), #PB_All )
BindWidgetEvent( widget_2, @all_event(), #PB_All )

; 4)
Procedure all_widget_event()
  Select event_widget
    Case widget_1
      Select event_type
        Case #PB_EventType_LeftButtonDown  
        Case #PB_EventType_LeftButtonUp   
        Case #PB_EventType_MouseEnter 
        Case #PB_EventType_MouseLeave  
          ; .......  
      EndSelect
      
    Case widget_2
      Select event_type
        Case #PB_EventType_LeftButtonDown  
        Case #PB_EventType_LeftButtonUp   
        Case #PB_EventType_MouseEnter 
        Case #PB_EventType_MouseLeave  
          ; .......  
      EndSelect
      
      ; ........
  EndSelect
EndProcedure

BindWidgetEvent( #PB_All, @all_widget_event(), #PB_All )


Debug ""
PostWidgetEvent( widget_1, #PB_EventType_MouseLeave )
PostWidgetEvent( widget_2, #PB_EventType_MouseLeave )

PostWidgetEvent( widget_1, #PB_EventType_MouseMove )
PostWidgetEvent( widget_2, #PB_EventType_MouseMove )

; PostWidgetEvent( #PB_All )








; #PB_EventType_Resize
; #PB_EventType_ReturnKey
; #PB_EventType_ResizeEnd
; 
; #__event_Draw
; #PB_EventType_Free         
; #PB_EventType_Create
; #PB_EventType_Drop
; 
; #PB_EventType_Repaint
; #PB_EventType_ScrollChange
; 
; #PB_EventType_CloseWindow
; #PB_EventType_MaximizeWindow
; #PB_EventType_MinimizeWindow
; #PB_EventType_RestoreWindow
; 
; #PB_EventType_MouseWheelX
; #PB_EventType_MouseWheelY
; 
; #PB_EventType_Free    
; #PB_EventType_Drop
; #PB_EventType_Create
; #PB_EventType_SizeItem
; 
; #PB_EventType_Repaint
; #PB_EventType_ResizeEnd
; #PB_EventType_ScrollChange
; 
; #PB_EventType_CloseWindow
; #PB_EventType_MaximizeWindow
; #PB_EventType_MinimizeWindow
; #PB_EventType_RestoreWindow
; 
; #PB_EventType_MouseEnter   
; #PB_EventType_MouseLeave   
; #PB_EventType_MouseMove    
; #PB_EventType_MouseWheel    
; #PB_EventType_LeftButtonDown
; #PB_EventType_LeftButtonUp
; #PB_EventType_LeftClick      
; #PB_EventType_LeftDoubleClick
; #PB_EventType_RightButtonDown 
; #PB_EventType_RightButtonUp 
; #PB_EventType_RightClick    
; #PB_EventType_RightDoubleClick 
; #PB_EventType_MiddleButtonDown 
; #PB_EventType_MiddleButtonUp 
; #PB_EventType_Focus         
; #PB_EventType_LostFocus     
; #PB_EventType_KeyDown     
; #PB_EventType_KeyUp 
; #PB_EventType_Input 
; #PB_EventType_Resize
; #PB_EventType_StatusChange
; #PB_EventType_TitleChange
; #PB_EventType_Change
; #PB_EventType_DragStart
; #PB_EventType_returnKey
; #PB_EventType_CloseItem
; 
; #PB_EventType_Down
; #PB_EventType_Up
; 
; #PB_EventType_MouseWheelX
; #PB_EventType_MouseWheelY
; #__event_Draw


; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 292
; FirstLine = 267
; Folding = ------
; EnableXP