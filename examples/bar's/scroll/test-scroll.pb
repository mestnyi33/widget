
XIncludeFile "../../../widgets.pbi" 
EnableExplicit
UseWidgets( )

;
; example demo resize draw splitter - OS gadgets   -bar
; 

CompilerIf #PB_Compiler_IsMainFile
   Global Button_2, Splitter_4
   
   If Open(0, 0, 0, 360, 200, "", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
       Button_2 = widget::ScrollArea(10, 10, 0, 0, 150, 150, 1) : widget::CloseList()   
      ;Button_2 = widget::ScrollArea(10, 10, 300, 140, 150, 150, 1) : widget::CloseList()   
       Debug ""
       Resize(Button_2, #PB_Ignore, #PB_Ignore, 300, 141 )
      ; Splitter_4 = widget::Splitter(30, 30, 300, 140, -1, Button_2, #PB_Splitter_Vertical)
      
      WaitClose( )
   EndIf
CompilerEndIf

CompilerIf #PB_Compiler_IsMainFile = 99
   If Open(0, 0, 0, 250,240, "Example 1: Creation of a basic objects.", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      SetColor(root(), #PB_Gadget_BackColor, RGBA(244, 245, 233, 255))
      
      
      Define *g._S_WIDGET = Editor(20,20,200,100);, #__flag_autosize);|#__flag_transparent)
      AddItem(*g, -1, ~"define W_0 = form( 282, \"Window_0\" )")
      
      
      Debug *g\scroll\h\bar\button[1]\size
      
      WaitClose( )
   EndIf
CompilerEndIf

; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; CursorPosition = 37
; Folding = 8
; EnableXP