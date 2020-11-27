IncludePath "../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
  
  Uselib(Widget)
  EnableExplicit
  
  Define set.b = 1
  Define add.b = 1
  Define a,i, Event, Text.s
  Define g, *g._s_widget
  
  Define m.s=#LF$
  
  Text.s = "This is a long line" + m.s +
           "Who should show," + m.s +
           "I have to write the text in the box or not." + m.s +
           "The string must be very long" + m.s +
           "Otherwise it will not work."
  
  CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
    LoadFont(0, "Arial", 16)
  CompilerElse
    LoadFont(0, "Arial", 11)
  CompilerEndIf 
  
  
  Text.s = "This is a long line." + m.s +
           "Who should show." + 
           m.s +
           m.s +
           m.s +
           m.s +
           "I have to write the text in the box or not." + 
           m.s +
           m.s +
           m.s +
           m.s +
           "The string must be very long." + m.s +
           "Otherwise it will not work." ;+ m.s +
  
; ;   If ReadFile(0, "/Users/as/Documents/GitHub/widget/widgets.pbi")   ; if the file could be read, we continue...
; ;     Text = ""
; ;     ;While Eof(0) = 0              ; loop as long the 'end of file' isn't reached
; ;     Text + ReadString(0, #PB_File_IgnoreEOL) ;; + m.s      ; display line by line in the debug window
; ;                                              ;Wend
; ;     CloseFile(0)                             ; close the previously opened file
; ;                                              ;Debug Text
; ;   Else
; ;     MessageRequester("Information","Couldn't open the file!")
; ;   EndIf
  
  If OpenWindow(0, 0, 0, 800, 600, "EditorGadget", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered)
    Open(0, 10,10)
    
    g = Editor( 0, 0, 0, 0 , #__text_WordWrap) 
    *g = Editor(0, 0, 0, 0) 
    
    If g
      If set
        SetText(g, Text.s) 
      EndIf
      If add
        For a = 0 To 2
          AddItem(g, a, "Line "+Str(a))
        Next
        AddItem(g, 7+a, "_")
        For a = 4 To 6
          AddItem(g, a, "Line "+Str(a))
        Next
      EndIf
      ;SetFont(g, FontID(0))
    EndIf
    
    If *g
      If set
        SetText(*g, Text.s) 
      EndIf
      If add
        For a = 0 To 2
          AddItem(*g, a, "Line "+Str(a))
        Next
        AddItem(*g, 7+a, "_")
        For a = 4 To 6
          AddItem(*g, a, "Line "+Str(a))
        Next
      EndIf
      ;SetFont(*g, FontID(0))
    EndIf
    
    Splitter(8, 35, 800-16, 600-16-35,g,*g, #PB_Splitter_Vertical|#__flag_autosize)
    
    If Not g
      SetState(widget(), 0)
    EndIf
    
    If Not *g
      SetState(widget(), 800)
    EndIf
    
    Repeat 
      Event = WaitWindowEvent()
    Until Event = #PB_Event_CloseWindow
  EndIf
CompilerEndIf

; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = --
; EnableXP