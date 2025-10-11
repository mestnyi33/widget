IncludePath "../../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseWidgets( )
  Global *this._s_widget, width=450, height=400
  
  ;\\
  Procedure events_widgets()
    Select WidgetEvent()
      Case #__event_Resize
        Debug  "resize "+ EventWidget( )\frame_width( ) +"x"+ EventWidget( )\frame_height( )
      
    EndSelect
  EndProcedure
  
  Define i, img = 0
  Define pos = 100
      
  If Open( 0, 0, 0, width+20, height+20, "resize demo", #PB_Window_SystemMenu | #PB_Window_ScreenCentered )
    a_init(root( ))
    
    *this = ListView( 50,50,200,200, #__flag_gridlines | #__flag_Borderless )
    
    For i = 1 To 6
      AddItem(*this, -1, "tree_add_item_"+Str(i), -1, -1) 
    Next 
    
    Bind(*this, @events_widgets( ))
    
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 10
; FirstLine = 6
; Folding = -
; EnableXP
; DPIAware