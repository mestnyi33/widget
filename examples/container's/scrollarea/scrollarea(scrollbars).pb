XIncludeFile "../../../widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
  UseWidgets( )
  
  EnableExplicit
  Global Event.i, MyCanvas, *spl1,*spl2
  Global x=100,y=100, width=420, height=420 , focus
  
  Procedure ScrollBars_ChangeEvents( )
     Debug " ---- " + ClassFromEvent( WidgetEvent( ))
  EndProcedure
  
  
  If Not OpenWindow(0, 0, 0, width+x*2+20, height+y*2+20, "Move/Drag Canvas Image", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered) 
    MessageRequester("Fatal error", "Program terminated.")
    End
  EndIf
  
  MyCanvas = GetCanvasGadget(OpenRootWidget(0, 10, 10));, #PB_Ignore, #PB_Ignore, #PB_Canvas_Keyboard, @Canvas_CallBack()))
   a_init( root() )
  
  ; Define *mdi = ScrollAreaWidget(0,0,0,0, 308,232,1,#__flag_autosize)
  ; Define *mdi = ScrollAreaWidget(x,y,width, height, 288,212,1)
  Define *mdi = ScrollAreaWidget(10, 10, 160,95, 288,212,1) ; reClip - Window 140 75 - 124 59
  ; 
  Debug " * "+WidgetWidth(*mdi, #__c_inner)+" "+WidgetHeight(*mdi, #__c_inner)
  
  ; add childrens to mdi gadget
  Define *g0 = ButtonWidget(20, 20, 288,212, "button", #__flag_Textleft|#__flag_Texttop)
  Define *g1 = ButtonWidget(50, 50, 288,212, "button", #__flag_Textleft|#__flag_Texttop)
  
  ; Debug " - test parent - mdi show and size scroll bars - "
  ; ResizeWidget(*mdi,#PB_Ignore,#PB_Ignore,308,232 )
  ; ResizeWidget(*mdi,#PB_Ignore,#PB_Ignore,307,#PB_Ignore )
   ResizeWidget(*mdi,#PB_Ignore,#PB_Ignore,#PB_Ignore,231 )
  ; ResizeWidget(*mdi,#PB_Ignore,#PB_Ignore,307,231 )
  
  ; Debug " - test child - mdi show and size scroll bars - "
  ; ResizeWidget(*g0,#PB_Ignore,#PB_Ignore,392,368 )
  ; ResizeWidget(*g0,113,#PB_Ignore,#PB_Ignore,#PB_Ignore )
  ; ResizeWidget(*g0,#PB_Ignore,189,#PB_Ignore,#PB_Ignore )
  ; ResizeWidget(*g0,113,189,#PB_Ignore,#PB_Ignore )
  
   
  BindWidgetEvent( *mdi, @ScrollBars_ChangeEvents( ), #__event_ScrollChange ) 
  
  Repeat
    Event = WaitWindowEvent()
  Until Event = #PB_Event_CloseWindow
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 26
; FirstLine = 22
; Folding = -
; EnableXP