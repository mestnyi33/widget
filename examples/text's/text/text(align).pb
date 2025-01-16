;XIncludeFile "../../../../widgets.pbi" 
XIncludeFile "../../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
   test_align = 1
   
   Define Text.s = "Text"
   Define i, Width = 200
   
   If Open(0, 0, 0, Width+20, 760, "text alignment test", #PB_Window_SizeGadget | #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      Text(10,  10, Width, 65, Text, #__flag_BorderFlat);, #__flag_Textleft)
      Text(10,  10+65+10, Width, 65, Text, #__flag_BorderFlat|#__flag_Texttop)
      Text(10, 160, Width, 65, Text, #__flag_BorderFlat|#__flag_Textright)
      Text(10, 160+65+10, Width, 65, Text, #__flag_BorderFlat|#__flag_Textbottom)
      
      Text(10, 310, Width, 65, Text, #__flag_BorderFlat|#__flag_Textcenter|#__flag_Textleft)
      Text(10, 310+65+10, Width, 65, Text, #__flag_BorderFlat|#__flag_Textcenter|#__flag_Texttop)
      Text(10, 460, Width, 65, Text, #__flag_BorderFlat|#__flag_Textcenter|#__flag_Textright)
      Text(10, 460+65+10, Width, 65, Text, #__flag_BorderFlat|#__flag_Textcenter|#__flag_Textbottom)
      
      Text(10, 610, Width, 140, Text, #__flag_BorderFlat|#__flag_Textcenter)
      
      For i=0 To 8
         SetAlign(ID(i), 0, 1,0,1,0)
      Next
      
      Repeat
         Define Event = WaitWindowEvent()
      Until Event = #PB_Event_CloseWindow
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 11
; FirstLine = 4
; Folding = -
; EnableXP
; DPIAware