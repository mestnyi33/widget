XIncludeFile "../../../widgets.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseLib(widget)

  Global.i gEvent, gQuit
  Global *Image, *Button, *Button2, *ComboBox
  
  Procedure _SetAlignment( *this._S_widget, mode.i, left.i=0, top.i=0, right.i=0, bottom.i=0 )
    ProcedureReturn SetAlignment( *this, mode, left, top, right, bottom )
  EndProcedure
    
  Procedure Window_0()
    If Open(0, 0, 0, 250, 310, "Demo show&hide scrollbar buttons", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered)
       *Button = Button( 5,   245, 240,  25, "")
      *ComboBox = Button( 5,   245+30, 240, 30,"")
      ;*Image = Button(10, 10, 230,  225, "")
      *Image = Window( 10, 10, 230-#__window_frame_size*2,  225-#__window_frame_size*2-#__window_caption_height, "", #PB_Window_SystemMenu)
      *Button2 = Button(10, 10, 230-20-#__window_frame_size*2,  225-20-#__window_frame_size*2-#__window_caption_height, "")  : CloseList( )
      
      _SetAlignment(*Image, 0, 1,1,1,1 )
      _SetAlignment(*Button2, 0, 1,1,1,1 )
      
      _SetAlignment(*Button, 0, 1,0,1,1 )
      _SetAlignment(*ComboBox, 0, 1,0,1,1 )
    EndIf
  EndProcedure
  
  Window_0()
  
  Repeat
    gEvent= WaitWindowEvent()
    
    Select gEvent
      Case #PB_Event_CloseWindow
        gQuit= #True
    EndSelect
    
  Until gQuit
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = -
; EnableXP