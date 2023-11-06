

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
;       ;Debug "button1"
;       Define *butt2 = Button(50, 50, 80, 50,"02") : SetClass(*butt2, GetText(widget()))  
;       ;Debug "button1"
;       Define *splitt1 = Splitter(20, 20, 180, 150, *butt1, *butt2) : SetClass(*splitt1, "-0-")  
;       ;Debug "splitter1"
      
      ;\\ 2-test
      Define *splitt1 = Splitter(20, 20, 180, 150, -1, -1) : SetClass(*splitt1, "-0-")  
      OpenList( *splitt1 )
      Define *butt1 = Button(10, 10, 80, 50,"01") : SetClass(*butt1, GetText(*butt1))  
      Define *butt2 = Button(50, 50, 80, 50,"02") : SetClass(*butt2, GetText(*butt2))  
      CloseList( )
      
      ;resize(*splitt1, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
;       ;\\ 3-test
;       Define *butt1 = Button(10, 10, 80, 50,"021") : SetClass(*butt1, GetText(*butt1))  
;       Define *butt2 = Button(50, 50, 80, 50,"022") : SetClass(*butt2, GetText(*butt2))  
      
      ForEach EnumWidget( )
         Debug "position "+ EnumWidget( )\class 
      Next
      
      Debug ""
      ForEach EnumWidget( )
         If EnumWidget( )\parent\FirstWidget( )
            Debug ""+ EnumWidget( )\class +" - "+ EnumWidget( )\parent\FirstWidget( )\class +" <-> "+ EnumWidget( )\parent\LastWidget( )\class
         EndIf
         If EnumWidget( )\FirstWidget( )
            Debug "first "+ EnumWidget( )\class +" - "+ EnumWidget( )\FirstWidget( )\class
         EndIf
         If EnumWidget( )\LastWidget( )
            Debug "last "+ EnumWidget( )\class +" - "+ EnumWidget( )\LastWidget( )\class
         EndIf
      Next
      
      WaitClose( )
   EndIf   
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 26
; FirstLine = 6
; Folding = -
; EnableXP