
; 
; demo state

IncludePath "../../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   test_delete = 1
   
   
   
   
   Global._s_WIDGET *g, *g0, *g1, *g2
   
   
   Procedure free_events()
      If Not is_root_(EventWidget())
         If *g0 <> EventWidget()
            If *g = EventWidget()
               *g = 0
            EndIf
            
            Debug "   [free] - "+EventWidget()\class
            ProcedureReturn 5
         EndIf
      EndIf
   EndProcedure
   
   If Open(1, 100, 50, 525, 435+40, "demo tree state", #PB_Window_SystemMenu)
      *g0 = Container(30, 115, 250, 100 )
      *g1 = Button(10, 10, 30, 30, "0" )
      *g2 = Button(60, 10, 30, 30, "1" ) 
      *g = Splitter(10, 15, 250, 100, *g1, *g2 )
      CloseList( )
      
      
      Debug ""+roots( )\haschildren +" root childrens count"
      Debug ""+*g0\haschildren +" container childrens count"
      If *g
         Debug ""+*g\haschildren +" splitter childrens count"
      EndIf
      Debug ""
      
     
      ;\\1 test free         ; 
       Bind(*g2, @free_events( ), #__event_Free)
      ; Bind(#PB_All, @free_events( ), #__event_Free)
     
      ;__gui\event\queuesmask = 1
      Free( Root( ))
      ;Free( *g0)
      ;Free( *g)    
      ;ResetEvents( Root( ))
      ;__gui\event\queuesmask = 0
      
      ;\\2 test free
      ; Bind(*g2, @free_events( ), #__event_Free)
      ; Bind(#PB_All, @free_events( ), #__event_Free)
     
     
      Debug ""
      Debug "---after free---"
      Debug ""+roots( )\haschildren +" root childrens count"
      Debug ""+*g0\haschildren +" container childrens count"
      If *g
         Debug ""+*g\haschildren +" splitter childrens count"
      EndIf
      Debug ""
      
      WaitClose()
      Debug "---after close---"
      Debug ListSize(widgets())
      Debug MapSize(roots())
   EndIf
CompilerEndIf

; IDE Options = PureBasic 6.21 - C Backend (MacOS X - x64)
; CursorPosition = 48
; FirstLine = 40
; Folding = --
; EnableXP
; DPIAware