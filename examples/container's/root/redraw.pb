IncludePath "../../../"
XIncludeFile "widgets.pbi"


CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   test_draw_repaint = 1
   ;test_startdrawing = 1
   
   ;\\
   Open(0, 0, 0, 300, 200, "window_0", #PB_Window_SystemMenu |
                                       #PB_Window_SizeGadget |
                                       #PB_Window_MinimizeGadget |
                                       #PB_Window_MaximizeGadget )
   
   SetClass(Root( ), "window_0_root" )
   Button(10,10,200,50,"window_0_root_butt_1")
   SetClass(Widget( ), "window_0_root_butt_1" )
   Button(10,65,200,50,"window_0_root_butt_2")
   SetClass(Widget( ), "window_0_root_butt_2" )
   
   ;\\
   Open(1, 200, 100, 300, 200, "window_1", #PB_Window_SystemMenu |
                                           #PB_Window_SizeGadget |
                                           #PB_Window_MinimizeGadget |
                                           #PB_Window_MaximizeGadget )
   
   SetClass(Root( ), "window_1_root" )
   Button(10,10,200,50,"window_1_root_butt_1")
   SetClass(Widget( ), "window_1_root_butt_1" )
   Button(10,65,200,50,"window_1_root_butt_2")
   SetClass(Widget( ), "window_1_root_butt_2" )
   
   ;\\
   Open(2, 400, 200, 300, 200, "window_2", #PB_Window_SystemMenu |
                                           #PB_Window_SizeGadget |
                                           #PB_Window_MinimizeGadget |
                                           #PB_Window_MaximizeGadget )
   
   SetClass(Root( ), "window_2_root" )
   Button(10,10,200,50,"window_2_root_butt_1")
   SetClass(Widget( ), "window_2_root_butt_1" )
   Button(10,65,200,50,"window_2_root_butt_2")
   SetClass(Widget( ), "window_2_root_butt_2" )
   
   Procedure EnumRoot( *callbak )
      ; 1. Сохраняем в локальную переменную
      Define *root._s_ROOT = Root( ) 
      
      ; 2. Отматываем в самое начало (к первому/нижнему окну)
      While *root\PrevRoot( ) : *root = *root\PrevRoot( ) : Wend
      
      ; 3. Рисуем все элементы по порядку (снизу вверх)
      While *root 
         CallCFunctionFast( *callbak, *root )
         *Root = *root\NextRoot( ) 
      Wend
   EndProcedure
   ;\\
   Debug "--- enumerate all widgets ---"
;    ForEach roots( )
;       Debug "     window "+ roots( )\class
;       If StartEnum( roots( ) )
;          Debug "       gadget - "+ Widget()\class
;          StopEnum( )
;       EndIf
;    Next
   Procedure roots(*r._s_ROOT)
      Debug "     window "+ *r\class
      If StartEnum( *r )
         Debug "       gadget - "+ Widget()\class
         StopEnum( )
      EndIf
   EndProcedure : EnumRoot( @roots( ))
   
   WaitClose( )
CompilerEndIf
; IDE Options = PureBasic 6.30 - C Backend (MacOS X - x64)
; CursorPosition = 75
; FirstLine = 56
; Folding = -
; EnableXP
; DPIAware