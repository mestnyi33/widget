﻿XIncludeFile "../../../../widgets.pbi" 
UseWidgets( )

Global i, *CHILD._s_widget, *CONT2,*CONT1._s_widget, *root1._s_widget, *root2._s_widget


Procedure show_DEBUG( )
   Define line.s
   ;\\ 
   Debug "---->>"
   ForEach widgets( )
      If widgets( )\root = *root1
         line = "  ";+ widgets( )\class +" "
         
         If widgets( )\BeforeWidget( )
            line + widgets( )\BeforeWidget( )\class +" <<  "    ;  +"_"+widgets( )\BeforeWidget( )\txt\string
         Else
            line + "-------- <<  " 
         EndIf
         
         line + widgets( )\class ; widgets( )\txt\string
         
         If widgets( )\AfterWidget( )
            line +"  >> "+ widgets( )\AfterWidget( )\class ;+"_"+widgets( )\AfterWidget( )\txt\string
         Else
            line + "  >> --------" 
         EndIf
         
         Debug line
      EndIf
   Next
   Debug "<<----"
   
   ;\\ 
   Debug "---->>"
   ForEach widgets( )
      If widgets( )\root = *root2
         line = "  ";+ widgets( )\class +" "
         
         If widgets( )\BeforeWidget( )
            line + widgets( )\BeforeWidget( )\class +" <<  "    ;  +"_"+widgets( )\BeforeWidget( )\txt\string
         Else
            line + "-------- <<  " 
         EndIf
         
         line + widgets( )\class ; widgets( )\txt\string
         
         If widgets( )\AfterWidget( )
            line +"  >> "+ widgets( )\AfterWidget( )\class ;+"_"+widgets( )\AfterWidget( )\txt\string
         Else
            line + "  >> --------" 
         EndIf
         
         Debug line
      EndIf
   Next
   Debug "<<----"
EndProcedure

Procedure events_widgets()
   Select WidgetEvent()
      Case #__event_LeftClick
         If i 
            SetParent(*CHILD, *CONT2)
         Else
            SetParent(*CHILD, *CONT1)
         EndIf
         
         show_DEBUG( )
         i!1
   EndSelect
EndProcedure

; Shows possible flags of ButtonGadget in action...
If Open(1, 150, 110, 222, 470, "ROOT1", #PB_Window_SystemMenu) : SetClass(widget( ), "ROOT1" )
   *root1 = root( )
   *CONT1 = Container(20, 180, 200, 200) : SetClass(widget( ), "CONT2" ) 
   Button(10,20, 200, 30, "CONT2_but1", #PB_Button_Toggle) : SetClass(widget( ), "CONT2_but1" )
   CloseList()
EndIf

If Open(2, 0, 0, 222, 470, "ROOT2", #PB_Window_SystemMenu | #PB_Window_ScreenCentered) : SetClass(widget( ), "ROOT2" )
   *root2 = root( )
   *CONT2 = Container(10, 10, 200, 200) : SetClass(widget( ), "CONT1" ) 
   Button(10,20, 200, 30, "CONT1_but1", #PB_Button_Toggle) : SetClass(widget( ), "CONT1_but1" )
   *CHILD = Container(10, 10, 100, 100) : SetClass(widget( ), "CHILD" )
   Button(-25, 10, 100, 40, "CHILD_but1") : SetClass(widget( ), "CHILD_but1" )
   CloseList()
   CloseList()
   
   Button(10,430, 200, 30, "change parent", #PB_Button_Toggle) : SetClass(widget( ), "change_parent" )
;    
    SetParent(*CHILD, *CONT1)
    SetParent(*CHILD, *CONT2)
   
   show_DEBUG( )
   
   WaitEvent( @events_widgets() )
EndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; Folding = ---
; EnableXP
; DPIAware