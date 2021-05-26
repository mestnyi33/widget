XIncludeFile "../../../widgets.pbi" 

Uselib(widget)

Open(OpenWindow(#PB_Any, 150, 150, 649, 441, "button - draw parent-inner-clip coordinate", #__Window_SizeGadget | #__Window_SystemMenu)) 
a_init( root( ) )
scrollstep = transform()\grid\size

SetColor(ScrollArea(30,30,450-2,250-2, 440,750, scrollstep), #__color_back, $C0F2AEDA)

Button(60,60,450,250,"button")

WaitClose( )
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; EnableXP