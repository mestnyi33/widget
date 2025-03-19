; 1785 - time add widget 10000
XIncludeFile "../../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
  UseWidgets( )
  Global show, ev, *g._s_widget, *b, i, time, Sw = 350, Sh = 300, wcount=1000
  
  Procedure events_widgets()
    Debug ""+EventWidget()+ " - widget event - " +WidgetEvent()
  EndProcedure
  
  If Open(0, 0, 0, 305+305, 500, "ScrollArea", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    *g = ScrollArea(310, 10, 290, 300, Sw, Sh, 1, #PB_ScrollArea_Flat)
    SetColor(*g, #PB_Gadget_BackColor, $00FFFF)
    Bind(*g, @events_widgets(), #__event_ScrollChange )
    Bind(*g, @events_widgets(), #__event_Resize )
    
    Button(10,  10, 230, 30,"Button 1")
    Button(50,  50, 230, 30,"Button 2") ;: SetAlign(widget(), #__align_right)
    Button(90,  90, 230, 30,"Button 3")
    Text(130, 130, 330, 20,"This is the content of a ScrollAreaWidget!", #__flag_text_Right)
    ; SetColor(widget(), #PB_Gadget_BackColor, -1)
    
    *b = Button(Sw-130, Sh-30, 130, 30,"Button")
    CloseList()
    
    ;
    Splitter(10,10,590,480, 0, Splitter(0,0,0,0, g,*g, #PB_Splitter_Vertical))
    
    If wcount
      OpenList(*g)
      time = ElapsedMilliseconds()
      For i=1 To wcount
        If Bool(i>wcount-110)
          Button((wcount-i)*2, (wcount-i)*2, 130, 30,"Button"+Str(i))
        Else
          Button(Sw-130, Sh-30, 130, 30,"Button"+Str(i))
        EndIf
      Next
      CloseList()
    EndIf
    
    
    Repeat 
    	ev = WaitWindowEvent()
    	If ev = - 1
    		If show = 0
    			show = 1
    		   Debug  Str(ElapsedMilliseconds()-time) + " - time add widget "+ wcount
         EndIf
    	EndIf
    Until ev = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 20
; FirstLine = 16
; Folding = --
; EnableXP
; DPIAware