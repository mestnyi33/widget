

IncludePath "../../"
XIncludeFile "widgets.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   Uselib(Widget )
   
   If Open(0, 0, 0, 230, 200, "z-order", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      a_init(root())
      
;       ;\\ 1-test
;       Define *butt1 = Button(10, 10, 80, 50,"01") : SetClass(*butt1, GetText(widget()))  
;       Define *butt2 = Button(50, 50, 80, 50,"02") : SetClass(*butt2, GetText(widget()))  
;       Define *splitt1 = Splitter(20, 20, 180, 150, *butt1, *butt2) : SetClass(*splitt1, "-0-")  
      
      ;\\ 2-test
      Define *splitt1 = Splitter(20, 20, 180, 150, -1, -1) : SetClass(*splitt1, "-0-")  
      OpenList( *splitt1 )
      Define *butt1 = Button(10, 10, 80, 50,"01") : SetClass(*butt1, GetText(*butt1))  
      Define *butt2 = Button(50, 50, 80, 50,"02") : SetClass(*butt2, GetText(*butt2))  
      CloseList( )
      
      ;\\
      ForEach widgets(  )
         Debug "position "+ widgets(  )\class 
      Next
      
      Debug ""
      ForEach widgets(  )
         If widgets(  )\parent\FirstWidget( )
            Debug ""+ widgets(  )\class +" - "+ widgets(  )\parent\FirstWidget( )\class +" <-> "+ widgets(  )\parent\LastWidget( )\class
         EndIf
         If widgets(  )\FirstWidget( )
            Debug "first "+ widgets(  )\class +" - "+ widgets(  )\FirstWidget( )\class
         EndIf
         If widgets(  )\LastWidget( )
            Debug "last "+ widgets(  )\class +" - "+ widgets(  )\LastWidget( )\class
         EndIf
      Next
      
      WaitClose( )
   EndIf   
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 39
; FirstLine = 22
; Folding = -
; EnableXP
; DPIAware