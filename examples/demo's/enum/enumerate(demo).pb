XIncludeFile "../../../widgets.pbi" : UseWidgets( )

; Shows using of several panels...
EnableExplicit
If Open(0, 0, 0, 322, 600, "enumeration widgets", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
   Define i, *parent._s_Widget
   
   For i = 1 To 3
      Window(10+i*30, i*140-120, 150, 95+2, "Window_" + Trim(Str(i)), #PB_Window_SystemMenu | #PB_Window_MaximizeGadget)  
      Container(5, 5, 120+2,85+2, #PB_Container_Flat)                                                    
      Button(10,10,100,30,"Button_" + Trim(Str(i+10)))                                                    
      Button(10,45,100,30,"Button_" + Trim(Str(i+20)))                                                   
      CloseList()                                                                                         
   Next
   
   i = 4
   Window(10+i*30, i*140-120, 150, 95+2, "Window_" + Trim(Str(i)), #PB_Window_SystemMenu | #PB_Window_MaximizeGadget)  
   *parent = Panel(5, 5, 120+2,85+2) 
   AddItem(*parent, -1, "item-1")
   Button(10,10,100,30,"Button14")                                                    
   Button(10,45,100,30,"Button15")                                                    
   AddItem(*parent, -1, "item-2")
   Button(10,10,100,30,"Button16")                                                    
   Button(10,45,100,30,"Button17")                                                    
   AddItem(*parent, -1, "item-3")
   Button(10,10,100,30,"Button18")                                                    
   Button(10,45,100,30,"Button19")                                                    
   CloseList()                                                                                         
   SetState(*parent, 1)
   
   Debug "--- enumerate all widgets ---"
   If StartEnum( root( ) )
      If is_window_( widget( ) )
         Debug "     window "+ Index( widget( ) )
      Else
         Debug "       gadget - "+ Index( widget( ) )
      EndIf
      StopEnum( )
   EndIf
   
   Debug "--- enumerate all gadgets ---"
   If StartEnum( root( ) )
      If Not is_window_( widget(  ) )
         Debug "     gadget - "+Index( widget( ) )
      EndIf
      StopEnum( )
   EndIf
   
   Debug "--- enumerate all windows ---"
   If StartEnum( root( ) )
      If is_window_( widget(  ) )
         Debug "     window " + Index( widget( ) )
      EndIf
      StopEnum( )
   EndIf
   
   Define Index = 12
   *parent = ID( Index )
   
   Debug "--- enumerate all (window="+ Str(Index) +") gadgets ---"
   If StartEnum( *parent )
      Debug "     gadget - "+ Index( widget( ) )
      StopEnum( )
   EndIf
   
   Index = 13
   *parent = ID( Index )
   Define item = 1
   
   Debug "--- enumerate all (gadget="+ Str(Index) +") (item="+Str(item)+") gadgets ---"
   If StartEnum( *parent, item )
      Debug "     gadget - "+ Index( widget( ) )
      StopEnum( )
   EndIf
   
   
   Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 35
; FirstLine = 21
; Folding = --
; EnableXP
; DPIAware