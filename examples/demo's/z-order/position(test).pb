IncludePath "../../../"
XIncludeFile "widgets.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseLib(Widget)
   
   If Open(0, 0, 0, 610, 210, "z-order", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      a_init(root())
      
      Container(5, 5, 200, 200) : SetClass(widget(), "-0-") 
      Button(10, 10, 80, 50,"01") : SetClass(widget(), GetText(widget()))  
      Button(50, 50, 80, 50,"02") : SetClass(widget(), GetText(widget()))  
      Button(90, 90, 80, 50,"03") : SetClass(widget(), GetText(widget()))  
      CloseList()
      
      Container(5+200, 5, 200, 200) : SetClass(widget(), "-1-") 
      Button(10, 10, 80, 50,"11") : SetClass(widget(), GetText(widget()))  
      Button(50, 50, 80, 50,"12") : SetClass(widget(), GetText(widget()))  
      Button(90, 90, 80, 50,"13") : SetClass(widget(), GetText(widget()))  
      CloseList()
      
      Container(5+200+200, 5, 200, 200) : SetClass(widget(), "-2-") 
      Button(10, 10, 80, 50,"21") : SetClass(widget(), GetText(widget()))  
      Button(50, 50, 80, 50,"22") : SetClass(widget(), GetText(widget()))  
      Button(90, 90, 80, 50,"23") : SetClass(widget(), GetText(widget()))  
      CloseList()
      
      
      ForEach widgets(  )
         If widgets(  )\parent\FirstWidget( )
            Debug ""+ widgets(  )\class +" "+ widgets(  )\parent\FirstWidget( )\class +" "+ widgets(  )\parent\LastWidget( )\class
         Else
            Debug widgets(  )\class
            Debug widgets(  )\FirstWidget( )\class
         EndIf
      Next
      
      ; debug_position(root())
      
      WaitClose()
   EndIf   
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 35
; FirstLine = 23
; Folding = -
; EnableXP
; DPIAware