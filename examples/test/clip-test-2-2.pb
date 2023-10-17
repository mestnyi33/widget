;- 
XIncludeFile "../../widgets.pbi"

EnableExplicit

Uselib( WIDGET )

;- GLOBALs
Global window_ide, 
       Splitter_ide,
       toolbar_design


Macro ToolBarButton( )
   Button(( Bool(widget( )\container = 0)*( widget( )\x+widget( )\width ) ), 5,30,30,Str(MacroExpandedCount) )
EndMacro

;-
Procedure ide_events( )
EndProcedure

Procedure ide_open( x=100,y=100,width=800,height=600 )
   Define root = Open( 1, x,y,width,height, "ide", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_MaximizeGadget | #PB_Window_MinimizeGadget ) 
   
   toolbar_design = Container( 0,0,150,50 )
;    ToolBarButton(  )
;    ToolBarButton( )
;    ToolBarButton( )
;    
;    ToolBarButton( )
;    ToolBarButton( )
;    
;    ToolBarButton( )
;    ToolBarButton( )
;    
;    ToolBarButton( )
;    ToolBarButton( )
;    ToolBarButton( )
;    ToolBarButton( )
;    
;    ToolBarButton( )
;    ToolBarButton( )
;    ToolBarButton( )
;    ToolBarButton( )
;    ToolBarButton( )
   Button( 5, 5, 500,30, "button test clip" )
   CloseList( )
   
   Resize(toolbar_design, #PB_Ignore, #PB_Ignore, width,height)
   
   ;Splitter_ide = widget::Splitter( 0,0,0,0, toolbar_design,-1, #__flag_autosize | #PB_Splitter_SecondFixed )

   
   ProcedureReturn window_ide
EndProcedure

;-
CompilerIf #PB_Compiler_IsMainFile 
   ide_open( )
   

   WaitClose( )
CompilerEndIf

; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 1
; Folding = -
; EnableXP