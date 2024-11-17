IncludePath "../../../"
XIncludeFile "widgets.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
   If Open(0, 0, 0, 610, 210, "z-order", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      a_init(root())
      
      ContainerWidget(5, 5, 200, 200) : SetWidgetClass(widget(), "-0-") 
      ButtonWidget(10, 10, 80, 50,"01") : SetWidgetClass(widget(), GetTextWidget(widget()))  
      ButtonWidget(50, 50, 80, 50,"02") : SetWidgetClass(widget(), GetTextWidget(widget()))  
      ButtonWidget(90, 90, 80, 50,"03") : SetWidgetClass(widget(), GetTextWidget(widget()))  
      CloseList()
      
      ContainerWidget(5+200, 5, 200, 200) : SetWidgetClass(widget(), "-1-") 
      ButtonWidget(10, 10, 80, 50,"11") : SetWidgetClass(widget(), GetTextWidget(widget()))  
      ButtonWidget(50, 50, 80, 50,"12") : SetWidgetClass(widget(), GetTextWidget(widget()))  
      ButtonWidget(90, 90, 80, 50,"13") : SetWidgetClass(widget(), GetTextWidget(widget()))  
      CloseList()
      
      ContainerWidget(5+200+200, 5, 200, 200) : SetWidgetClass(widget(), "-2-") 
      ButtonWidget(10, 10, 80, 50,"21") : SetWidgetClass(widget(), GetTextWidget(widget()))  
      ButtonWidget(50, 50, 80, 50,"22") : SetWidgetClass(widget(), GetTextWidget(widget()))  
      ButtonWidget(90, 90, 80, 50,"23") : SetWidgetClass(widget(), GetTextWidget(widget()))  
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