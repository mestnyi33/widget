;
;
;
EnableExplicit
Prototype pFunc( )

Structure _s_event_data
  ;*widget._s_Widget
  
  *back
  *type
  *item
  *data
EndStructure

Structure _s_event
  start.b
  List call._s_event_data( )
  List queue.i( )
EndStructure

Structure _s_Widget
  index.i
  event._s_event
EndStructure

Structure _s_struct
  *widget._s_Widget
  *function.pFunc
  event._s_event_data
EndStructure

Macro EventWidget( ) : *canvas\widget: EndMacro
Macro WidgetEvent( ) : *canvas\event: EndMacro
Macro WidgetEventType( ) : WidgetEvent( )\type: EndMacro
Macro WidgetEventItem( ) : WidgetEvent( )\item: EndMacro
Macro WidgetEventData( ) : WidgetEvent( )\data: EndMacro

Macro InitFunction( ) : *canvas\function : EndMacro
Macro CallFunction( ) : InitFunction( )( ) : EndMacro
    
DisableExplicit

Global *canvas._s_struct = AllocateStructure( _s_struct )

Global widget_1._s_Widget
Global widget_2._s_Widget
widget_1\index = 1
widget_2\index = 2

Enumeration #PB_EventType_FirstCustomValue
      CompilerIf Not Defined(PB_EventType_Resize, #PB_Constant)
        #PB_EventType_Resize
      CompilerEndIf
      CompilerIf Not Defined(PB_EventType_ReturnKey, #PB_Constant)
        #PB_EventType_ReturnKey
      CompilerEndIf
      
      #PB_EventType_ResizeEnd
      
      #PB_EventType_Draw
      #PB_EventType_Free         
      #PB_EventType_Create
      #PB_EventType_Drop
     
      #PB_EventType_Repaint
      #PB_EventType_ScrollChange
      
      #PB_EventType_CloseWindow
      #PB_EventType_MaximizeWindow
      #PB_EventType_MinimizeWindow
      #PB_EventType_RestoreWindow
      
      #PB_EventType_MouseWheelX
      #PB_EventType_MouseWheelY
    EndEnumeration
Procedure  UnPostWidgetEvent( *widget._s_WIDGET )
  
  EventWidget( ) = *widget
  
  If ListSize(*widget\event\queue( ))
        ForEach *widget\event\call( )
      ForEach *widget\event\queue( )
          If *widget\event\call( )\type = #PB_All Or  
             *widget\event\call( )\type = *widget\event\queue( )
            
            WidgetEvent( )\type = *widget\event\queue( )
            InitFunction( ) = *widget\event\call( )\back
            
            If CallFunction( )
              ; 
            EndIf
          EndIf
        Next
      Next
      
      ClearList(*widget\event\queue( ))
      *widget\event\start = 1
    EndIf
EndProcedure

Procedure BindWidgetEvent( *widget._s_WIDGET, *callback, eventtype.l = #PB_All, item.l = #PB_All )
  If *widget = #PB_All
    ; 4)
  Else
    InitFunction( ) = *callback
    AddElement( *widget\event\call( ))
    *widget\event\call( )\back = *callback
    *widget\event\call( )\type = eventtype
  EndIf
EndProcedure

Procedure UnBindWidgetEvent( *widget._s_WIDGET, *callback, eventtype.l = #PB_All, item.l = #PB_All )
  If *widget = #PB_All
    ; 4)
  Else
    ; 1)
    ; 2)
    ; 3)
  EndIf
EndProcedure

Procedure PostWidgetEvent( *widget._s_WIDGET, eventtype.l, *button = #PB_All, *data = #Null  )
  If *widget = #PB_All
    ; 4)
  Else
    ; 1)
    EventWidget( ) = *widget
    
    If *widget\event\start
      ForEach *widget\event\call( )
        If *widget\event\call( )\type = #PB_All Or  
           *widget\event\call( )\type = eventtype
          
          WidgetEvent( )\type = eventtype
          InitFunction( ) = *widget\event\call( )\back
          
          If CallFunction( )
            ; 
          EndIf
          
        EndIf
      Next
    Else
      AddElement( *widget\event\queue( ))
      *widget\event\queue( ) = eventtype
    EndIf
    
    EventWidget( ) = #Null
    WidgetEvent( )\type = #PB_All
    
    ; 2)
    ; 3)
  EndIf
EndProcedure

PostWidgetEvent( widget_1, #PB_EventType_Create )
PostWidgetEvent( widget_2, #PB_EventType_Create )

; 1)
Procedure create_event( )
  Debug #PB_Compiler_Procedure +" "+ EventWidget( )\index +" "+ WidgetEvent( )\type
EndProcedure

Procedure enter_event( )
  Debug #PB_Compiler_Procedure +" "+ EventWidget( )\index +" "+ WidgetEvent( )\type
EndProcedure

Procedure leave_event( )
  Debug #PB_Compiler_Procedure +" "+ EventWidget( )\index +" "+ WidgetEvent( )\type
EndProcedure

BindWidgetEvent( widget_1, @create_event(), #PB_EventType_Create )
BindWidgetEvent( widget_1, @enter_event(), #PB_EventType_MouseEnter )
BindWidgetEvent( widget_1, @leave_event(), #PB_EventType_MouseLeave )

BindWidgetEvent( widget_2, @create_event(), #PB_EventType_Create )
BindWidgetEvent( widget_2, @enter_event(), #PB_EventType_MouseEnter )
BindWidgetEvent( widget_2, @leave_event(), #PB_EventType_MouseLeave )

; 2)
Procedure el_event( )
  Debug "      "+#PB_Compiler_Procedure +" "+ EventWidget( )\index +" "+ WidgetEvent( )\type
EndProcedure

BindWidgetEvent( widget_1, @el_event(), #PB_EventType_Create )
BindWidgetEvent( widget_1, @el_event(), #PB_EventType_MouseEnter )
BindWidgetEvent( widget_1, @el_event(), #PB_EventType_MouseLeave )

BindWidgetEvent( widget_2, @el_event(), #PB_EventType_Create )
BindWidgetEvent( widget_2, @el_event(), #PB_EventType_MouseEnter )
BindWidgetEvent( widget_2, @el_event(), #PB_EventType_MouseLeave )

; 3)
Procedure all_event()
  Debug "              "+#PB_Compiler_Procedure +" "+ EventWidget( )\index +" "+ WidgetEvent( )\type
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
Debug ""
PostWidgetEvent( widget_1, #PB_EventType_MouseMove )
PostWidgetEvent( widget_2, #PB_EventType_MouseMove )

; PostWidgetEvent( #PB_All )


UnPostWidgetEvent( widget_1 )
UnPostWidgetEvent( widget_2 )


; #PB_EventType_Resize
; #PB_EventType_ReturnKey
; #PB_EventType_ResizeEnd
; 
; #PB_EventType_Draw
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
; #PB_EventType_Draw


; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = ------
; EnableXP