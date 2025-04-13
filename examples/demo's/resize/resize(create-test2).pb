IncludePath "../../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   test_resize = 1
   
   Global Button_1, Button_2, Button_3, Splitter_1, Splitter_2
   Global *g, r1, r2, g1, g2
   
   Procedure resize_events( )
      If EventWidget() = *g
         Debug " "+ EventWidget( )\class +" - "+ #PB_Compiler_Procedure +" "+ Width( EventWidget())
       ;  ResizeGadget( g2, X(*g, #__c_inner), Y(*g, #__c_inner), Width(*g, #__c_inner), Height(*g, #__c_inner))
        ; ResizeGadget( g2, X(*g, #__c_inner), Y(*g, #__c_inner), 40, Height(*g, #__c_inner))
         
;          SetWindowPos_( GadgetID(g2), #HWND_TOP, X(*g, #__c_inner), Y(*g, #__c_inner), Width(*g, #__c_inner), Height(*g, #__c_inner), #SWP_NOACTIVATE )
        ;  UpdateWindow_( GadgetID(g1))
         
      EndIf
   EndProcedure
   
   
   ;If Open(5, 0, 0, 200, 300, "resize", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered)
   If OpenWindow(5, 0, 0, 200, 300, "resize", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered)
      
      r1 = Open(5, 0, 0, 160, 60, "", #PB_Canvas_Container )
      g1 = GetCanvasGadget(r1)
      SetBackColor(root(), $ff00fffff)
      Define root = root( ) 
      SetClass(root, "ROOT") 
      *g = Container( 90,30,50,50 ) 
       SetBackColor(*g, $ffff00fff)
     
;       ;UseGadgetList(GadgetID(GetCanvasGadget(root)))
;       ;OpenGadgetList(GetCanvasGadget(root))
;       r2=Open(5, 40, 20, 60, 60 )
;       g2 = GetCanvasGadget(r2)
;       ;ResizeGadget(GetCanvasGadget(root), 0, 0, 60, 60 )
;       SetBackColor(root(), $ff00fffff)
      
    ; g2 = ButtonGadget(-1, 0,0,0,0,"")
      ;g2 = GetCanvasGadget(r1)
      g2 = CanvasGadget(-1, 0,50,50,50)
      r2 = Open(5, 20, 20, 20, 20,"",0, 0, g2 )
      ; SetBackColor(root(), $ff00fffff)
      ResizeGadget( g2, X(*g, #__c_inner), Y(*g, #__c_inner), Width(*g, #__c_inner), Height(*g, #__c_inner))
      

            
      Bind( #PB_All, @resize_events( ), #__event_resize )
      Debug "--"
      WaitClose( )
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.20 (Windows - x64)
; CursorPosition = 40
; FirstLine = 22
; Folding = -
; EnableXP