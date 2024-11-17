XIncludeFile "../../../widgets.pbi" : UseWidgets( )

; Shows using of several panels...
EnableExplicit
If OpenRootWidget(0, 0, 0, 322, 600, "enumeration widgets", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
   Define i, *parent._s_Widget
   
   For i = 1 To 3
      WindowWidget(10+i*30, i*140-120, 150, 95+2, "Window_" + Trim(Str(i)), #PB_Window_SystemMenu | #PB_Window_MaximizeGadget)  
      ContainerWidget(5, 5, 120+2,85+2, #PB_Container_Flat)                                                    
      ButtonWidget(10,10,100,30,"Button_" + Trim(Str(i+10)))                                                    
      ButtonWidget(10,45,100,30,"Button_" + Trim(Str(i+20)))                                                   
      CloseWidgetList()                                                                                         
   Next
   
   i = 4
   WindowWidget(10+i*30, i*140-120, 150, 95+2, "Window_" + Trim(Str(i)), #PB_Window_SystemMenu | #PB_Window_MaximizeGadget)  
   *parent = PanelWidget(5, 5, 120+2,85+2) 
   AddItem(*parent, -1, "item-1")
   ButtonWidget(10,10,100,30,"Button14")                                                    
   ButtonWidget(10,45,100,30,"Button15")                                                    
   AddItem(*parent, -1, "item-2")
   ButtonWidget(10,10,100,30,"Button16")                                                    
   ButtonWidget(10,45,100,30,"Button17")                                                    
   AddItem(*parent, -1, "item-3")
   ButtonWidget(10,10,100,30,"Button18")                                                    
   ButtonWidget(10,45,100,30,"Button19")                                                    
   CloseWidgetList()                                                                                         
   SetState(*parent, 1)
   
   Debug "--- enumerate all widgets ---"
   If StartEnum( root( ) )
      If is_window_( widget( ) )
         Debug "     window "+ widget( )\index
      Else
         Debug "       gadget - "+ widget( )\index
      EndIf
      StopEnum( )
   EndIf
   
   Debug "--- enumerate all gadgets ---"
   If StartEnum( root( ) )
      If Not is_window_( widget(  ) )
         Debug "     gadget - "+widget(  )\index
      EndIf
      StopEnum( )
   EndIf
   
   Debug "--- enumerate all windows ---"
   If StartEnum( root( ) )
      If is_window_( widget(  ) )
         Debug "     window " + widget(  )\index
      EndIf
      StopEnum( )
   EndIf
   
   Define index = 12
   *parent = WidgetID( index )
   
   Debug "--- enumerate all (window="+ Str(index) +") gadgets ---"
   If StartEnum( *parent )
      Debug "     gadget - "+ widget(  )\index
      StopEnum( )
   EndIf
   
   index = 13
   *parent = WidgetID( index )
   Define item = 1
   
   Debug "--- enumerate all (gadget="+ Str(index) +") (item="+Str(item)+") gadgets ---"
   If StartEnum( *parent, item )
      Debug "     gadget - "+ widget(  )\index
      StopEnum( )
   EndIf
   
   
   Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 66
; FirstLine = 46
; Folding = --
; EnableXP
; DPIAware