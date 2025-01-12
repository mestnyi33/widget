﻿XIncludeFile "../../../widgets.pbi" 
; bug scrollstep

CompilerIf #PB_Compiler_IsMainFile
  UseWidgets( )
  
  Procedure events_gadgets()
    ;Debug ""+EventGadget()+ " - gadget event - " +EventType()
  EndProcedure
  
  Procedure events_widgets()
    ;Debug ""+Str(Index(EventWidget( )))+ " - widget event - " +WidgetEvent( )+ " bar - " +this()\item+ " direction - " +this()\data 
  EndProcedure
  
   If Open(0, 0, 0, 850, 430, "Container", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    SetColor( widget( ), #__color_Back, $FFFFFFFF )
    
    Container( 10,10,200,200, #PB_Container_Flat ) 
    SetColor( widget( ), #__color_Back, $FF95E3F6 )
    ToolBar( widget( ), #PB_ToolBar_Large|#PB_ToolBar_Buttons | #PB_ToolBar_Bottom )
    BarButton(0, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/New.png"), #PB_ToolBar_Normal, "New")
    BarButton(1, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Open.png"), #PB_ToolBar_Normal, "Open")
    BarButton(2, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Save.png"), #PB_ToolBar_Normal, "Save")
    BarSeparator( )
    BarButton(3, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Cut.png"), #PB_ToolBar_Normal, "Cut")
    BarButton(4, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Copy.png"), #PB_ToolBar_Normal, "Copy")
    BarButton(5, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png"), #PB_ToolBar_Normal, "Paste")
    BarSeparator( )
    BarButton(6, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Find.png"), #PB_ToolBar_Normal, "Find")
    CloseList( )
    
    Container( 220,10,200,200, #PB_Container_Flat ) 
    SetColor( widget( ), #__color_Back, $FF95E3F6 )
    ToolBar( widget( ), #PB_ToolBar_Small|#PB_ToolBar_InlineText|#PB_ToolBar_Buttons | #PB_ToolBar_Bottom )
    BarButton(0, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/New.png"), #PB_ToolBar_Normal, "New")
    BarButton(1, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Open.png"), #PB_ToolBar_Normal, "Open")
    BarButton(2, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Save.png"), #PB_ToolBar_Normal, "Save")
    BarSeparator( )
    BarButton(3, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Cut.png"), #PB_ToolBar_Normal, "Cut")
    BarButton(4, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Copy.png"), #PB_ToolBar_Normal, "Copy")
    BarButton(5, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png"), #PB_ToolBar_Normal, "Paste")
    BarSeparator( )
    BarButton(6, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Find.png"), #PB_ToolBar_Normal, "Find")
    CloseList( )
    
    Container( 430,10,200,200, #PB_Container_Flat ) 
    SetColor( widget( ), #__color_Back, $FF95E3F6 )
    ToolBar( widget( ), #PB_ToolBar_Large|#PB_ToolBar_InlineText|#PB_ToolBar_Buttons | #PB_ToolBar_Right )
    BarButton(0, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/New.png"), #PB_ToolBar_Normal, "New")
    BarButton(1, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Open.png"), #PB_ToolBar_Normal, "Open")
    BarButton(2, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Save.png"), #PB_ToolBar_Normal, "Save")
    BarSeparator( )
    BarButton(3, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Cut.png"), #PB_ToolBar_Normal, "Cut")
    BarButton(4, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Copy.png"), #PB_ToolBar_Normal, "Copy")
    BarButton(5, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png"), #PB_ToolBar_Normal, "Paste")
    BarSeparator( )
    BarButton(6, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Find.png"), #PB_ToolBar_Normal, "Find")
    CloseList( )
    
    Container( 640,10,200,200, #PB_Container_Flat ) 
    SetColor( widget( ), #__color_Back, $FF95E3F6 )
    ToolBar( widget( ), #PB_ToolBar_Large|#PB_ToolBar_InlineText | #PB_ToolBar_Left )
    BarButton(0, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/New.png"), #PB_ToolBar_Normal, "New")
    BarButton(1, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Open.png"), #PB_ToolBar_Normal, "Open")
    BarButton(2, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Save.png"), #PB_ToolBar_Normal, "Save")
    BarSeparator( )
    BarButton(3, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Cut.png"), #PB_ToolBar_Normal, "Cut")
    BarButton(4, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Copy.png"), #PB_ToolBar_Normal, "Copy")
    BarButton(5, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png"), #PB_ToolBar_Normal, "Paste")
    BarSeparator( )
    BarButton(6, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Find.png"), #PB_ToolBar_Normal, "Find")
    CloseList( )
    
    ;\\
    Container( 10,220,200,200, #PB_Container_Flat ) 
    SetColor( widget( ), #__color_Back, $FF95E3F6 )
    ToolBar( widget( ), #PB_ToolBar_Large )
    BarButton(0, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/New.png"), #PB_ToolBar_Normal, "New")
    BarButton(1, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Open.png"), #PB_ToolBar_Normal, "Open")
    BarButton(2, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Save.png"), #PB_ToolBar_Normal, "Save")
    BarSeparator( )
    BarButton(3, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Cut.png"), #PB_ToolBar_Normal, "Cut")
    BarButton(4, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Copy.png"), #PB_ToolBar_Normal, "Copy")
    BarButton(5, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png"), #PB_ToolBar_Normal, "Paste")
    BarSeparator( )
    BarButton(6, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Find.png"), #PB_ToolBar_Normal, "Find")
    CloseList( )
    
    Container( 220,220,200,200, #PB_Container_Flat ) 
    SetColor( widget( ), #__color_Back, $FF95E3F6 )
    ToolBar( widget( ), #PB_ToolBar_Small|#PB_ToolBar_InlineText )
    BarButton(0, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/New.png"), #PB_ToolBar_Normal, "New")
    BarButton(1, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Open.png"), #PB_ToolBar_Normal, "Open")
    BarButton(2, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Save.png"), #PB_ToolBar_Normal, "Save")
    BarSeparator( )
    BarButton(3, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Cut.png"), #PB_ToolBar_Normal, "Cut")
    BarButton(4, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Copy.png"), #PB_ToolBar_Normal, "Copy")
    BarButton(5, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png"), #PB_ToolBar_Normal, "Paste")
    BarSeparator( )
    BarButton(6, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Find.png"), #PB_ToolBar_Normal, "Find")
    CloseList( )
    
    Container( 430,220,200,200, #PB_Container_Flat ) 
    SetColor( widget( ), #__color_Back, $FF95E3F6 )
    ToolBar( widget( ), #PB_ToolBar_Large|#PB_ToolBar_Buttons | #PB_ToolBar_Right )
    BarButton(0, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/New.png"), #PB_ToolBar_Normal, "New")
    BarButton(1, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Open.png"), #PB_ToolBar_Normal, "Open")
    BarButton(2, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Save.png"), #PB_ToolBar_Normal, "Save")
    BarSeparator( )
    BarButton(3, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Cut.png"), #PB_ToolBar_Normal, "Cut")
    BarButton(4, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Copy.png"), #PB_ToolBar_Normal, "Copy")
    BarButton(5, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png"), #PB_ToolBar_Normal, "Paste")
    BarSeparator( )
    BarButton(6, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Find.png"), #PB_ToolBar_Normal, "Find")
    CloseList( )
    
    Container( 640,220,200,200, #PB_Container_Flat ) 
    SetColor( widget( ), #__color_Back, $FF95E3F6 )
    ToolBar( widget( ), #PB_ToolBar_Large | #PB_ToolBar_Left )
    BarButton(0, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/New.png"), #PB_ToolBar_Normal, "New")
    BarButton(1, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Open.png"), #PB_ToolBar_Normal, "Open")
    BarButton(2, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Save.png"), #PB_ToolBar_Normal, "Save")
    BarSeparator( )
    BarButton(3, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Cut.png"), #PB_ToolBar_Normal, "Cut")
    BarButton(4, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Copy.png"), #PB_ToolBar_Normal, "Copy")
    BarButton(5, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png"), #PB_ToolBar_Normal, "Paste")
    BarSeparator( )
    BarButton(6, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Find.png"), #PB_ToolBar_Normal, "Find")
    CloseList( )
    
    WaitClose( )
  EndIf
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 11
; FirstLine = 9
; Folding = -
; Optimizer
; EnableXP