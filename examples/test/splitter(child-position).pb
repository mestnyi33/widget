

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
      ForEach __widgets(  )
         Debug "position "+ __widgets(  )\class 
      Next
      
      Debug ""
      ForEach __widgets(  )
         If __widgets(  )\parent\FirstWidget( )
            Debug ""+ __widgets(  )\class +" - "+ __widgets(  )\parent\FirstWidget( )\class +" <-> "+ __widgets(  )\parent\LastWidget( )\class
         EndIf
         If __widgets(  )\FirstWidget( )
            Debug "first "+ __widgets(  )\class +" - "+ __widgets(  )\FirstWidget( )\class
         EndIf
         If __widgets(  )\LastWidget( )
            Debug "last "+ __widgets(  )\class +" - "+ __widgets(  )\LastWidget( )\class
         EndIf
      Next
      
      WaitClose( )
   EndIf   
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (Windows - x64)
; CursorPosition = 39
; FirstLine = 15
; Folding = -
; EnableXP
; DPIAware