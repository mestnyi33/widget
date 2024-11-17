XIncludeFile "../../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseWidgets( )
  
  Global *g._s_widget, *g2._s_widget
  
  Procedure events_widgets()
    ;; ClearDebugOutput()
    
    Select WidgetEvent()
      Case #__event_Focus
        Debug  ""+IDWidget(EventWidget())+" "+GetWidgetClass(EventWidget())+" - event( FOCUS ) "+GetState(EventWidget()) +" "+ WidgetEventItem()
      Case #__event_LostFocus
        Debug  ""+IDWidget(EventWidget())+" "+GetWidgetClass(EventWidget())+" - event( LOSTFOCUS ) "+GetState(EventWidget()) +" "+ WidgetEventItem()
        
      Case #__event_Drop
        Debug  ""+IDWidget(EventWidget())+" "+GetWidgetClass(EventWidget())+" - event( DROP ) "+GetState(EventWidget()) +" "+ WidgetEventItem()
        
      Case #__event_DragStart
        Debug  ""+IDWidget(EventWidget())+" "+GetWidgetClass(EventWidget())+" - event( DRAGSTART ) "+GetState(EventWidget()) +" "+ WidgetEventItem()
        
      Case #__event_Up
        Debug  ""+IDWidget(EventWidget())+" "+GetWidgetClass(EventWidget())+" - event( UP ) "+GetState(EventWidget()) +" "+ WidgetEventItem()
        
      Case #__event_Down
        Debug  ""+IDWidget(EventWidget())+" "+GetWidgetClass(EventWidget())+" - event( DOWN ) "+GetState(EventWidget()) +" "+ WidgetEventItem()
        
      Case #__event_Change
        Debug  ""+IDWidget(EventWidget())+" "+GetWidgetClass(EventWidget())+" - event( CHANGE ) "+GetState(EventWidget()) +" "+ WidgetEventItem()
        
      Case #__event_ScrollChange
        Debug  ""+IDWidget(EventWidget())+" "+GetWidgetClass(EventWidget())+" - event( SCROLL ) "+GetState(EventWidget()) +" "+ WidgetEventItem() +" "+ WidgetEventData()
        
      Case #__event_StatusChange
        Debug  ""+IDWidget(EventWidget())+" "+GetWidgetClass(EventWidget())+" - event( STATUS ) "+GetState(EventWidget()) +" "+ WidgetEventItem()
        
      Case #__event_LeftClick
        Debug  ""+IDWidget(EventWidget())+" "+GetWidgetClass(EventWidget())+" - event( LEFTCLICK ) "+GetState(EventWidget()) +" "+ WidgetEventItem()
        
      Case #__event_Left2Click
        Debug  ""+IDWidget(EventWidget())+" "+GetWidgetClass(EventWidget())+" - event( LEFT2CLICK ) "+GetState(EventWidget()) +" "+ WidgetEventItem()
        
      Case #__event_RightClick
        Debug  ""+IDWidget(EventWidget())+" "+GetWidgetClass(EventWidget())+" - event( RIGHTCLICK ) "+GetState(EventWidget()) +" "+ WidgetEventItem()
        
      Case #__event_Right2Click
        Debug  ""+IDWidget(EventWidget())+" "+GetWidgetClass(EventWidget())+" - event( RIGHT2CLICK ) "+GetState(EventWidget()) +" "+ WidgetEventItem()
        
    EndSelect
  EndProcedure
  
  ;\\
  If Open(0, 0, 0, 360, 460, "TreeGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    Define i,a
    ;\\
    *g = TreeWidget(10, 10, 165, 440, #__flag_gridLines)
    For a = 0 To 5
      AddItem (*g, -1, "Item " + Str(a) + " of the Tree", -1, 0) ; define Tree content
      AddItem (*g, -1, "Subitem " + Str(a) + " of the Tree", -1, 1) ; define Tree content
      
      i = (CountItems( *g )-1)
      If i%2
        SetItemState(*g, i, #PB_Tree_Selected) 
      EndIf
    Next
    
    ;\\
    *g2 = TreeWidget(185, 10, 165, 440, #__flag_checkboxes)
    For a = 0 To 5
      AddItem (*g2, -1, "Item " + Str(a) + " of the Tree", -1, 0) ; define Tree content
      AddItem (*g2, -1, "Subitem " + Str(a) + " of the Tree", -1, 1) ; define Tree content
      
      i = (CountItems( *g2 )-1)
      If i%2
        SetItemState(*g2, i, #PB_Tree_Selected) 
      EndIf
    Next
    
    ;\\
    Bind(*g, @events_widgets())
    Bind(*g2, @events_widgets())
    
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 11
; FirstLine = 7
; Folding = --
; EnableXP
; DPIAware