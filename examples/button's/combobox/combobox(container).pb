IncludePath "../../../" 
XIncludeFile "widgets.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
   UseWidgets( )
   EnableExplicit
   test_clip = 1
   ;test_draw_area = 1
   
   Define a,i, Height=60
   
   UsePNGImageDecoder()
   LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/world.png")
   LoadImage(1, #PB_Compiler_Home + "examples/sources/Data/Geebee2.bmp")
   LoadImage(2, #PB_Compiler_Home + "examples/sources/Data/PureBasic.bmp")
   CopyImage(1,3)
   CopyImage(2,4)
   ResizeImage(3, 32, 32)
   
   CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
      Define ImageSize.NSSize
      ImageSize\width = 16
      ImageSize\height = 16
      CocoaMessage(0, ImageID(4), "setSize:@", @ImageSize)
   CompilerElse
      ResizeImage(4, 16, 16)
   CompilerEndIf
   
   
   Procedure TestContainer_events( )
      Protected *g._s_WIDGET = EventWidget( )
      If WidgetEvent( ) = #__event_Resize
         Debug " resize "
;          If StartEnum( *g )
;             Resize( widgets(), #PB_Ignore, #PB_Ignore, Width(*g), #PB_Ignore )
;             StopEnum( )
;          EndIf
      EndIf
   EndProcedure
   
   Procedure TestAddButton_events()
      Static clk
      Protected size = 40
      Protected Y
      Protected *p._s_WIDGET = EventWidget( )\parent
      Protected *g1._s_WIDGET = EventWidget( )\data
      
      If WidgetEvent( ) = #__event_LeftClick
         Debug " clk "+ GetText(EventWidget( ))
         clk!1
         Y = clk*size
         Resize( *g1, #PB_Ignore, #PB_Ignore, #PB_Ignore, Y)
          Protected y1 = Y(EventWidget( )) + Height(EventWidget( ))
         If StartEnum( *p )
            If Y(widgets( )) > y1 And *g1 <> widgets()
               Debug widgets()\class
               If clk
                  Resize( widgets(), #PB_Ignore, Y(widgets( ))+size, #PB_Ignore, #PB_Ignore)
               Else
                  Resize( widgets(), #PB_Ignore, Y(widgets( ))-size, #PB_Ignore, #PB_Ignore)
               EndIf
            EndIf
            StopEnum( )
         EndIf

      EndIf
      
   EndProcedure
   
   
   Procedure TestContainer( X,Y,Width,Height, flag=0)
      Protected *g._s_WIDGET
      *g = ScrollArea(X,Y,Width,Height, Width,Height, 1, flag )
      Bind(*g, @TestContainer_events())
      CloseList( )
      ProcedureReturn *g
   EndProcedure
   
   Procedure TestAddButton( *p._s_WIDGET, X,Y,Width,Height, text$, flag=0)
      Protected *g._s_WIDGET
      Protected *g1._s_WIDGET
      OpenList(*p)
      *g = ComboBox(1,Y,Width,Height, flag)
      *g1 = Container(1,Y+Height+5,Width,0 ):CloseList( )
      SetText( *g, text$)
      SetData( *g, *g1 )
      SetAlign( *g, 0, 0,0,1,0)
      Bind(*g, @TestAddButton_events())
      CloseList( )
      ProcedureReturn *g
   EndProcedure
   
   If Open(0, 0, 0, 270, 320, "Combo buttons demo", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      Define *g = TestContainer( 0, 0, 270, 300 )
      TestAddButton(*g, 10, 10, 250, 50, "ComboBox1", #PB_ComboBox_Editable|#PB_ComboBox_UpperCase)
      SetImage( widget(), 0)
      
      TestAddButton(*g, 10, 70, 250, 50, "ComboBox2", #PB_ComboBox_LowerCase)
      SetImage( widget(), 1)
      
      TestAddButton(*g, 10, 130, 250, 50, "ComboBox3")
      SetImage( widget(), 2)
      
      
      
      WaitClose( ) 
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.21 (Windows - x64)
; CursorPosition = 58
; FirstLine = 33
; Folding = ---
; EnableXP
; DPIAware