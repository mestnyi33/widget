IncludePath "../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile = 99
   EnableExplicit
   UseWidgets( )
   ;test_resize = 1
   
   Global Button_1, Button_2, Button_3, Splitter_1, Splitter_2
   
   
   If OpenWindow(0, 0, 0, 380, 400, "ScrollBarGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      ; gadgets
      Button_1 = ScrollAreaGadget(#PB_Any, 0, 0, 0, 0, 150, 150, 1) 
      CloseGadgetList() 
      Button_2 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "button_1")
      
      Splitter_1 = SplitterGadget(#PB_Any, 10, 10, 285+30, 140, Button_1, Button_2, #PB_Splitter_Vertical|#PB_Splitter_Separator|#PB_Splitter_FirstFixed)
      
      Open(0, 10, 160, 285+30+2, 140+2)
      Button_1 = ScrollArea( 0, 0, 0, 0, 150, 150, 1) 
      Define *g=Panel( 20,20,100,50) :AddItem( *g,-1,"panel item open"): CloseList( )
      ;Define *g=Tree( 20,20,100,50) :AddItem( *g,-1,"panel item open")
      CloseList() 
      Button_2 = Button( 0, 0, 0, 0, "button_1")
      Splitter_1 = Splitter(0, 0, 285+30, 140, Button_1,Button_2, #PB_Splitter_Vertical|#PB_Splitter_FirstFixed)
      
      WaitClose()
   EndIf
CompilerEndIf

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   Global._s_WIDGET *g
   
   
   If Open(0, 0, 0, 380, 400, "MDI", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
;       *g = MDI(20, 20, 160,95)
;       Resize(AddItem(*g, -1, "form_0"), 30, 20, 120, 20)
;       Resize(AddItem(*g, -1, "form_1"), 40, 1, 120, 47)
;       CloseList( )
      
      *g = MDI(200, 20, 160,95)
      ;Resize(AddItem(*g, -1, "form_0"), 30, 20, 120, 20)
      Resize(AddItem(*g, -1, "form_1"), 50, 43, 120, 20)
      CloseList( )
      
      WaitClose()
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.30 (Windows - x64)
; CursorPosition = 45
; Folding = +
; EnableXP
; DPIAware