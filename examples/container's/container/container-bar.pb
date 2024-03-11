XIncludeFile "../../../widgets.pbi" 
; bug scrollstep

CompilerIf #PB_Compiler_IsMainFile
  Uselib(widget)
  
  Procedure events_gadgets()
    ;Debug ""+EventGadget()+ " - gadget event - " +EventType()
  EndProcedure
  
  Procedure events_widgets()
    ;Debug ""+Str(GetIndex(this()\widget))+ " - widget event - " +this()\event+ " bar - " +this()\item+ " direction - " +this()\data 
  EndProcedure
  
  Procedure TabViewType( *this._s_widget, position.i, size.i = #PB_Default )
     *this = *this\parent
     ; reset position
      *this\fs[1] = 0
      *this\fs[2] = 0
      *this\fs[3] = 0
      *this\fs[4] = 0
      
      If position = 4
         *this\TabBox( )\hide = 1
      Else
         *this\TabBox( )\hide = 0
      EndIf
      
      If position = 1
         *this\TabBox( )\bar\vertical = 1
         If size = #PB_Default
            *this\fs[1] = *this\ToolBarHeight + 2 ; #__panel_width
         Else
            *this\fs[1] = size
         EndIf
      EndIf
      
      If position = 3
         *this\TabBox( )\bar\vertical = 1
         If size = #PB_Default
            *this\fs[3] = *this\ToolBarHeight + 2 ; #__panel_width
         Else
            *this\fs[3] = size
         EndIf
      EndIf
      
      If position = 0
         *this\TabBox( )\bar\vertical = 0
         If size = #PB_Default
            *this\fs[2] = *this\ToolBarHeight + 2 ; #__panel_height
         Else
            *this\fs[2] = size
         EndIf
      EndIf
      
      If position = 2
         *this\TabBox( )\bar\vertical = 0
         If size = #PB_Default
            *this\fs[4] = *this\ToolBarHeight + 2 ; #__panel_height
         Else
            *this\fs[4] = size
         EndIf
      EndIf
      
      If Resize( *this, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore )
         PostEventRepaint( *this\root )
      EndIf
   EndProcedure
   
   If Open(0, 0, 0, 430, 560, "Container", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    Container( 10,10,200,200);, #PB_Container_BorderLess ) 
    SetColor( widget( ), #__color_Back, $FF95E3F6 )
    ToolBar( widget( ), #PB_ToolBar_Large )
    TabViewType( widget( ), 0 )
    ToolBarButton(0, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/New.png"))
    ToolBarButton(1, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Open.png"), #PB_ToolBar_Normal, "Open")
    ToolBarButton(2, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Save.png"));, #PB_ToolBar_Normal, "save")
    Separator( )
    ToolBarButton(3, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Cut.png"))
    ToolBarButton(4, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Copy.png"), #PB_ToolBar_Normal, "Copy")
    ToolBarButton(5, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png"))
    Separator( )
    ToolBarButton(6, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Find.png"))
    CloseList( )
    
    Container( 10,220,200,200);, #PB_Container_Single ) 
    SetColor( widget( ), #__color_Back, $FF95E3F6 )
    ToolBar( widget( ), #PB_ToolBar_Large )
    TabViewType( widget( ), 1 )
    ToolBarButton(0, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/New.png"))
    ToolBarButton(1, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Open.png"), #PB_ToolBar_Normal, "Open")
    ToolBarButton(2, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Save.png"));, #PB_ToolBar_Normal, "save")
    Separator( )
    ToolBarButton(3, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Cut.png"))
    ToolBarButton(4, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Copy.png"), #PB_ToolBar_Normal, "Copy")
    ToolBarButton(5, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png"))
    Separator( )
    ToolBarButton(6, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Find.png"))
    CloseList( )
    
    
    Container( 220,10,200,200);, #__flag_BorderLess ) 
    SetColor( widget( ), #__color_Back, $FF95E3F6 )
    ToolBar( widget( ), #PB_ToolBar_Large )
    TabViewType( widget( ), 2 )
    ToolBarButton(0, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/New.png"))
    ToolBarButton(1, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Open.png"), #PB_ToolBar_Normal, "Open")
    ToolBarButton(2, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Save.png"));, #PB_ToolBar_Normal, "save")
    Separator( )
    ToolBarButton(3, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Cut.png"))
    ToolBarButton(4, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Copy.png"), #PB_ToolBar_Normal, "Copy")
    ToolBarButton(5, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png"))
    Separator( )
    ToolBarButton(6, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Find.png"))
    CloseList( )
    
    Container( 220,220,200,200);, #__flag_Single ) 
    SetColor( widget( ), #__color_Back, $FF95E3F6 )
    ToolBar( widget( ), #PB_ToolBar_Large )
    TabViewType( widget( ), 3 )
    ToolBarButton(0, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/New.png"))
    ToolBarButton(1, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Open.png"), #PB_ToolBar_Normal, "Open")
    ToolBarButton(2, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Save.png"));, #PB_ToolBar_Normal, "save")
    Separator( )
    ToolBarButton(3, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Cut.png"))
    ToolBarButton(4, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Copy.png"), #PB_ToolBar_Normal, "Copy")
    ToolBarButton(5, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png"))
    Separator( )
    ToolBarButton(6, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Find.png"))
    CloseList( )
    
    WaitClose( )
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 79
; FirstLine = 57
; Folding = ---
; EnableXP