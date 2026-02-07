;IncludePath "../../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
   Global._s_widget *g_OBJECT, *g_TYPE, *g_FLAG
   Global  i, vert=100, horiz=100, Width=450, Height=400
   
   Procedure events_widgets()
      Debug EventString( Events( )) +" "+ Widget( )\class    
;       If Events( ) = #__event_Change
;          Debug " ----- change ----- " + Widget( )\class     
;       EndIf
   EndProcedure
   
   If Open( 0, 0, 0, Width+205, Height+30, "flag", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      *g_TYPE = Widget::ListView(Width, 10, 195, 250) 
      ;*g_TYPE = Widget::Panel(Width, 10, 195, 250) 
      ;*g_TYPE = Widget::Container(Width, 10, 195, 250) 
      SetActive(*g_TYPE)
      For i=0 To 31
         AddItem(*g_TYPE, -1, ClassFromType(i))
      Next
      SetState(*g_TYPE, 1)
;       OpenList(*g_TYPE)
;       Button( 10,10,10,10,"")
;       CloseList()
      
      Bind( *g_TYPE, @events_widgets( ));, #__event_Change)
;        Bind( *g_TYPE, @events_widgets( ), #__event_Focus)
;        Bind( *g_TYPE, @events_widgets( ), #__event_Change)
       ;  Bind( *g_TYPE, @events_widgets( ), #__event_Resize)
       
   ;   Debug "-------"
    ;  Bind( *g_TYPE, @events_widgets( ), #__event_Change)
    ;  ResetEvents( Root())
    ;  Debug "11111111"
     ; ReDraw(Root())
     ; Debug "22222222"
      
      
      
      WaitClose( );@events_widgets( ))
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.21 - C Backend (MacOS X - x64)
; CursorPosition = 28
; FirstLine = 12
; Folding = -
; EnableXP
; DPIAware