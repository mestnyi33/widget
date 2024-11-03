;
;
;
EnableExplicit
Prototype pFunc( )

Structure _s_event_data
  ;*widget._s_Widget
  
  *back.pFunc
  *type
  *item
  *data
EndStructure

Structure _s_event
  List call._s_event_data( )
  List queue._s_event_data( )
EndStructure

Structure _s_Widget
  *data
  event._s_event
EndStructure

Structure _s_struct
  *widget._s_Widget
  event._s_event_data
EndStructure

Macro EventWidget( ) : *canvas\widget: EndMacro
Macro WidgetEvent( ) : *canvas\event: EndMacro
Macro WidgetEvent( ) : WidgetEvent( ): EndMacro
Macro WidgetEventItem( ) : WidgetEventItem( ): EndMacro
Macro WidgetEventData( ) : WidgetEventData( ): EndMacro

DisableExplicit

Global *canvas._s_struct = AllocateStructure( _s_struct )

Global widget_1._s_Widget
Global widget_2._s_Widget
widget_1\data = 1
widget_2\data = 2

Enumeration #PB_EventType_FirstCustomValue
  #PB_EventType_Create
EndEnumeration

Procedure  UnPostWidgetEvent( *widget._s_WIDGET )
  Protected result 
  
  If ListSize(*widget\event\queue( ))
    ForEach *widget\event\queue( )
      ForEach *widget\event\call( )
        If *widget\event\call( )\type = #PB_All Or  
           *widget\event\call( )\type = *widget\event\queue( )\type
          
          EventWidget( ) = *widget
          WidgetEvent( ) = *widget\event\queue( )\type
          WidgetEventItem( ) = *widget\event\queue( )\item
          WidgetEventData( ) = *widget\event\queue( )\data
          WidgetEvent( )\back = *widget\event\call( )\back
          
          result = WidgetEvent( )\back( )
          
          EventWidget( ) = #Null
          WidgetEvent( ) = #PB_All
          WidgetEventItem( ) = #PB_All
          WidgetEventData( ) = #Null
          
          If result
            Break 
          EndIf
        EndIf
      Next
    Next
    
    ClearList(*widget\event\queue( ))
  EndIf
EndProcedure

Procedure IsBindWidgetEvent( *widget._s_WIDGET, *callback, eventtype.l = #PB_All, item.l = #PB_All )
  Protected result
  
  PushListPosition( *widget\event\call( ) )
  ForEach *widget\event\call( )
    If *widget\event\call( )\back = *callback And 
       *widget\event\call( )\type = eventtype And 
       *widget\event\call( )\item = item
      result = *widget\event\call( )
      Break
    EndIf
  Next
  PopListPosition( *widget\event\call( ) )
  
  ProcedureReturn result
EndProcedure

Procedure BindWidgetEvent( *widget._s_WIDGET, *callback, eventtype.l = #PB_All, item.l = #PB_All )
  If *widget = #PB_All
    ; 4)
  Else
    ForEach *widget\event\call( )
      If *widget\event\call( )\back = *callback And 
         *widget\event\call( )\type = eventtype And 
         *widget\event\call( )\item = item
        ProcedureReturn *widget\event\call( )
      EndIf
    Next
    
    LastElement( *widget\event\call( ))
    AddElement( *widget\event\call( ))
    *widget\event\call( )\back = *callback
    *widget\event\call( )\type = eventtype
    *widget\event\call( )\item = item
  EndIf
EndProcedure

Procedure UnBindWidgetEvent( *widget._s_WIDGET, *callback, eventtype.l = #PB_All, item.l = #PB_All )
  Protected  result
  
  If *widget = #PB_All
    ; 4)
  Else
    ForEach *widget\event\call( )
      If *widget\event\call( )\back = *callback And 
         *widget\event\call( )\type = eventtype And 
         *widget\event\call( )\item = item
        DeleteElement( *widget\event\call( ) )
        Break
      EndIf
    Next
  EndIf
EndProcedure

Procedure PostWidgetEvent( *widget._s_WIDGET, eventtype.l, item = #PB_All, *data = #Null  )
  Protected result
  
  If *widget = #PB_All
    ; 4)
  Else
    
    If WidgetEvent( )\back
      ForEach *widget\event\call( )
        If *widget\event\call( )\type = #PB_All Or  
           *widget\event\call( )\type = eventtype
          
          EventWidget( ) = *widget
          WidgetEvent( ) = eventtype
          WidgetEventItem( ) = item
          WidgetEventData( ) = *data
          WidgetEvent( )\back = *widget\event\call( )\back
          
          result = WidgetEvent( )\back( )
          
          EventWidget( ) = #Null
          WidgetEvent( ) = #PB_All
          WidgetEventItem( ) = #PB_All
          WidgetEventData( ) = #Null
          
          If result
            Break 
          EndIf
        EndIf
      Next
    Else
      AddElement( *widget\event\queue( ))
      *widget\event\queue( )\type = eventtype
      *widget\event\queue( )\item = item
      *widget\event\queue( )\data = *data
    EndIf
    
  EndIf
EndProcedure

PostWidgetEvent( widget_1, #PB_EventType_Create )
PostWidgetEvent( widget_2, #PB_EventType_Create )

; 1)
Procedure create_event( )
  Debug #PB_Compiler_Procedure +" "+ EventWidget( )\data +" "+ WidgetEvent( )
  ;
  ; ProcedureReturn 1
EndProcedure

Procedure enter_event( )
  Debug #PB_Compiler_Procedure +" "+ EventWidget( )\data +" "+ WidgetEvent( )
EndProcedure

Procedure leave_event( )
  Debug #PB_Compiler_Procedure +" "+ EventWidget( )\data +" "+ WidgetEvent( )
EndProcedure

BindWidgetEvent( widget_1, @create_event(), #PB_EventType_Create )
BindWidgetEvent( widget_1, @create_event(), #PB_EventType_Create )
; UnBindWidgetEvent( widget_1, @create_event(), #PB_EventType_Create )
BindWidgetEvent( widget_1, @enter_event(), #PB_EventType_MouseEnter )
BindWidgetEvent( widget_1, @leave_event(), #PB_EventType_MouseLeave )

BindWidgetEvent( widget_2, @create_event(), #PB_EventType_Create )
BindWidgetEvent( widget_2, @enter_event(), #PB_EventType_MouseEnter )
BindWidgetEvent( widget_2, @leave_event(), #PB_EventType_MouseLeave )

; 2)
Procedure el_event( )
  Debug "      "+#PB_Compiler_Procedure +" "+ EventWidget( )\data +" "+ WidgetEvent( )
EndProcedure

BindWidgetEvent( widget_1, @el_event(), #PB_EventType_Create )
BindWidgetEvent( widget_1, @el_event(), #PB_EventType_MouseEnter )
BindWidgetEvent( widget_1, @el_event(), #PB_EventType_MouseLeave )

BindWidgetEvent( widget_2, @el_event(), #PB_EventType_Create )
BindWidgetEvent( widget_2, @el_event(), #PB_EventType_MouseEnter )
BindWidgetEvent( widget_2, @el_event(), #PB_EventType_MouseLeave )

; 3)
Procedure all_event()
  Debug "              "+#PB_Compiler_Procedure +" "+ EventWidget( )\data +" "+ WidgetEvent( )
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
PostWidgetEvent( widget_1, #PB_EventType_MouseEnter )
PostWidgetEvent( widget_2, #PB_EventType_MouseEnter )
Debug ""
PostWidgetEvent( widget_1, #PB_EventType_MouseLeave )
PostWidgetEvent( widget_2, #PB_EventType_MouseLeave )

; PostWidgetEvent( #PB_All )


UnPostWidgetEvent( widget_1 )
UnPostWidgetEvent( widget_2 )

Debug ""
PostWidgetEvent( widget_1, #PB_EventType_MouseMove )
PostWidgetEvent( widget_2, #PB_EventType_MouseMove )

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
; #PB_EventType_MouseMove    
; #PB_EventType_MouseLeave   
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
; CursorPosition = 336
; FirstLine = 296
; Folding = --0---
; EnableXP