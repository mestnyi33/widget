XIncludeFile "../../widgets.pbi" 
CompilerIf #PB_Compiler_IsMainFile ;= 99
   UseWidgets( )
   EnableExplicit
   test_clip = 1
   test_draw_area = 1
   
   Define a,i, Height=60, *g._s_WIDGET
   
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
   
   
   Procedure events_widgets()
      Protected ComboBox.s
      Protected eventtype = WidgetEvent( )
      If eventtype = #__event_Draw Or eventtype = #__event_MouseMove
         ProcedureReturn 
      EndIf
      If EventWidget( ) = EventWidget( )\root
         ProcedureReturn 
      EndIf
      
      ;ClearDebugOutput()
      
      Select eventtype
         Case #__event_Focus
            ComboBox.s = "focus "+Str(EventWidget( )\index)+" "+eventtype
         Case #__event_LostFocus
            ComboBox.s = "lostfocus "+Str(EventWidget( )\index)+" "+eventtype
         Case #__event_Change
            ComboBox.s = "change "+Str(EventWidget( )\index)+" "+eventtype
      EndSelect
      
      If eventtype = #__event_Focus
         Debug ComboBox.s +" - widget" +" get text - "+ GetText(EventWidget( ))
      Else
         If ComboBox.s <> "" 
            Debug ComboBox.s +" - widget " + EventWidget( )\class
            ComboBox.s = ""
         EndIf
      EndIf
      
   EndProcedure
   
   
   If Open(0, 0, 0, 615, 190, "ComboBox on the canvas", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      ;\\
      ComboBox(10, 10, 250, 50, #PB_ComboBox_Editable|#PB_ComboBox_UpperCase);|#PB_ComboBox_Image)
      For a = 1 To 31
         AddItem(ID(0), -1,"ComboBox editable... " + Str(a), (2))
      Next
      SetState(ID(0), 2)
      
      String(10, 70, 250, 50,"String editable...");, #__flag_child)
      
      *g=Spin(10, 130, 250, 50, 0, 100000000 )
      SetState(*g, 1000000)
      
      
      For i = 0 To 2
         ;  Bind(ID(i), @events_widgets())
      Next
      
      WaitClose( ) 
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.30 - C Backend (MacOS X - x64)
; CursorPosition = 1
; Folding = --
; EnableXP
; DPIAware