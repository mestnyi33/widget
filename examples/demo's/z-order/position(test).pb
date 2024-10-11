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
      
      
      ForEach __widgets(  )
         If __widgets(  )\parent\FirstWidget( )
            Debug ""+ __widgets(  )\class +" "+ __widgets(  )\parent\FirstWidget( )\class +" "+ __widgets(  )\parent\LastWidget( )\class
         Else
            Debug __widgets(  )\class
            Debug __widgets(  )\FirstWidget( )\class
         EndIf
      Next
      
      ; debug_position(root())
      
      WaitClose()
   EndIf   
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (Windows - x64)
; CursorPosition = 35
; FirstLine = 7
; Folding = -
; EnableXP
; DPIAware