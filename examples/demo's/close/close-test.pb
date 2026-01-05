
; 
; demo state

IncludePath "../../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
   Global._s_WIDGET *g, *g0, *g1, *g2
   
   
   Procedure widget_events()
      Protected item, itemstate
      
      ;ProcedureReturn 5
   EndProcedure
   
   test_delete = 1
   
   
   
   If Open(1, 100, 50, 525, 435+40, "demo tree state", #PB_Window_SystemMenu)
      *g0 = Container(30, 115, 250, 100 )
      *g1 = Button(10, 10, 30, 30, "1" )
      *g2 = Button(60, 10, 30, 30, "2" ) 
      *g = Splitter(10, 15, 250, 100, *g1, *g2 )
      CloseList( )
      
      Bind(*g2, @widget_events())
      
      Debug ""+roots( )\haschildren +" root childrens count"
      Debug ""+*g0\haschildren +" container childrens count"
      Debug ""+*g\haschildren +" splitter childrens count"
      Debug ""
      
      
      ReDraw(Root())
      Free(Root())
      
      Debug "------"
      PushListPosition(widgets( ))
      ForEach widgets( )
         Debug "p "+widgets( )\class +" "+ widgets( )\text\string +" "+ widgets( )\parent\class
      Next
      PopListPosition(widgets( ))
      
      If Root( )\FirstWidget( )
         Debug "  f "+ Root( )\FirstWidget( )\class +" "+ Root( )\FirstWidget( )\address
      EndIf
      
      WaitClose()
      Debug ListSize(widgets())
      Debug MapSize(roots())
   EndIf
CompilerEndIf


; IDE Options = PureBasic 6.21 (Windows - x64)
; CursorPosition = 59
; FirstLine = 19
; Folding = -
; EnableXP
; DPIAware