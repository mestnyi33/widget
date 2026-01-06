IncludePath "../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
   
   UseWidgets( )
   EnableExplicit
   
   Define set.b = 1
   Define add.b = 1
   Define a,i, Event, Text.s
   Define g, *g._s_widget
   
   Define m.s=#LF$
   
   CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
      LoadFont(0, "Arial", 16)
   CompilerElse
      LoadFont(0, "Arial", 11)
   CompilerEndIf 
   
   
   Text.s = "This is a long line." + m.s +
            "Who should show." + m.s +
            m.s +
            m.s +
            "I have to write the long long text in the box or not." + m.s +
            m.s +
            m.s +
            "The string must be very long." + m.s +
            "Otherwise it will not work."
   
;      If ReadFile(0, "C:\Users\user\Documents\GitHub\widget\widgets.pbi")   ; if the file could be read, we continue...
;         Text = ReadString(0, #PB_File_IgnoreEOL) 
;         CloseFile(0)                             ; close the previously opened file
;      Else
;        MessageRequester("Information","Couldn't open the file!")
;      EndIf
   
   If Open(0, 0, 0, 800, 600, "EditorGadget", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered)
      ; Open(0, 10, 10)
      
      g = Editor( 0, 0, 0, 0 , #__flag_Textwordwrap) : Hide(HBar(g), #True )
      *g = Editor(0, 0, 0, 0) 
      
      If g
         If set
            SetText(g, Text.s) 
         EndIf
         If add
            AddItem(g, 0, "add line first")
            AddItem(g, 4, "add line "+Str(4))
            AddItem(g, 8, "add line "+Str(8))
            AddItem(g, -1, "add line last")
         EndIf
         ;SetFont(g, FontID(0))
      EndIf
      
      If *g
         If set
            SetText(*g, Text.s) 
         EndIf
         If add
            AddItem(*g, 0, "add line first")
            AddItem(*g, 4, "add line "+Str(4))
            AddItem(*g, 8, "add line "+Str(8))
            AddItem(*g, -1, "add line last")
         EndIf
         ;SetFont(*g, FontID(0))
      EndIf
      
      Splitter(8, 35, 800-16, 600-16-35,g,*g, #PB_Splitter_Vertical|#__flag_autosize)
      
      If Not g
         SetState(Widget(), 0)
      EndIf
      
      If Not *g
         SetState(Widget(), 800)
      EndIf
      
      ResizeWindow( 0, #PB_Ignore, #PB_Ignore, 200, #PB_Ignore )
      ReDraw( Root( ))
      
      Debug ""+CountItems( g ) +" - count wrap items"
      Debug ""+CountItems( *g ) +" - count multi items"
      
      Repeat 
         Event = WaitWindowEvent()
      Until Event = #PB_Event_CloseWindow
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.21 - C Backend (MacOS X - x64)
; CursorPosition = 40
; FirstLine = 35
; Folding = --
; EnableXP
; DPIAware