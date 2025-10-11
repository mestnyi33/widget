IncludePath "../../../"
XIncludeFile "widgets.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
   Global *c, *s
   Global *butt1, *butt2
   Global *butt3, *butt4
   Global *butt5, *butt6
   Global._s_widget *w,*w1,*w2 ;
   
   Open(3, 0, 0, 455, 405, "hide/show widgets", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
   
   
   ;Button(10,5,50,35, "butt")
   Container(20,28,8,203)
   CloseList()
   
   *w = Panel(28, 28, 356, 203);, #__flag_Borderless)
      AddItem(*w, -1, "Панель 1")
      Button(5, 5, 80, 22,"кнопка 1")
      
      Procedure events_butt()
         Select EventWidget( )
            Case *butt1	
               HideItem(*w, 2, 1)
               Disable(*butt1,1)
               Disable(*butt2,0)
               
            Case *butt2	
               HideItem(*w, 2, 0)
               Disable(*butt1,0)
               Disable(*butt2,1)
               
            Case *butt3	
               DisableItem(*w, 2, 1)
               Disable(*butt3,1)
               Disable(*butt4,0)
               
            Case *butt4
               DisableItem(*w, 2, 0)
               Disable(*butt3,0)
               Disable(*butt4,1)
               
            Case *butt5
               Debug GetText( *butt5 )
                SetBarItemText(*w\tabbar, 1, GetText( *butt5 ) )
         EndSelect
      EndProcedure
      
      AddItem (*w, -1,"Панель 2")
      *butt1 = Button(10, 15, 80, 24,"hide item3")
      *butt2 = Button(95, 15, 80, 24,"show item3")
      Bind(*butt1, @events_butt(), #__event_LeftClick)
      Bind(*butt2, @events_butt(), #__event_LeftClick)
      *butt3 = Button(10, 44, 80, 24,"disable item3")
      *butt4 = Button(95, 44, 80, 24,"enable item3")
      Bind(*butt3, @events_butt(), #__event_LeftClick)
      Bind(*butt4, @events_butt(), #__event_LeftClick)
      *butt5 = String(10, 73, 165, 24,"change item2")
      Bind(*butt5, @events_butt(), #__event_Change)
      
      AddItem (*w, -1,"Панель 3")
      Button(10, 15, 80, 24,"Кнопка 4")
      Button(95, 15, 80, 24,"Кнопка 5")
      Button(180, 15, 80, 24,"Кнопка 6")
      AddItem (*w, -1,"Панель 4")
   CloseList()
   
   ; 
   SetState(*w,1)
   
   ;
   HideItem(*w, 2, 1)
   DisableItem(*w, 2, 1)
   
   ;
   Disable(*butt1,1)
   Disable(*butt3,1)
   
   ;
   WaitClose( )
   
CompilerEndIf
; IDE Options = PureBasic 6.20 (Windows - x64)
; CursorPosition = 62
; FirstLine = 47
; Folding = -
; EnableXP
; DPIAware