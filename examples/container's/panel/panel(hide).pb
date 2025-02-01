IncludePath "../../../"
XIncludeFile "widgets.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseWidgets( )
  
  Global *c, *s
  Global ._s_widget *w,*w1,*w2, *hide, *show ;
  
  Procedure Events()
    Select WidgetEvent( )
      Case #__Event_LeftClick
        
        Select GetText( EventWidget( ) )
          Case "hide_2"
            Hide(*c, 1)
            Disable(EventWidget( ), 1)
            Disable(*show, 0)
            
          Case "show_2" 
            Hide(*c, 0)
            Disable(EventWidget( ), 1)
             Disable(*hide, 0)
          
          Case "hide_3"
            Hide(*s, 1)
            
          Case "show_3" 
            Hide(*s, 0)
          
        EndSelect
        
        ;Case #PB_EventType_LeftButtonUp
        ClearDebugOutput( )
        
        If StartEnum(*w1);Root())
          If Not Hide(widget( )) ;And GetParent(widget()) = *w1
            Debug " class - " + widget( )\Class ;+" ("+ widget( )\item +" - parent_item)"
          EndIf
          StopEnum( )
        EndIf
        
     Case #__Event_Change
         Debug "hide c - "+Hide(*c)+" s - "+Hide(*s)
        
    EndSelect
  EndProcedure
  
  
  If OpenWindow(3, 0, 0, 455, 405, "hide/show widgets", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    Open(3)
    ;a_init(root())
    
     ;Button(10,5,50,35, "butt")
     
      *w=Panel     (8, 8, 356, 203)
      AddItem (*w, -1, "Панель 1")
      
      *w1=Panel (5, 30, 340, 166)
      AddItem(*w1, -1, "Под-Панель 1")
      
      Define *tree = Tree(5, 5, 180, 100, #__flag_Checkboxes|#PB_Tree_ThreeState)
      
      Define i
      For i=0 To 20
        If i=3
          AddItem(*tree, i, "long_long_long_item_"+ Str(i),-1, Bool(i=3 Or i=6))
        Else
          AddItem(*tree, i, "item_"+ Str(i))
        EndIf
      Next
      
      AddItem(*w1, -1, "Под-Панель 2")
      *hide = Button( 5, 5, 55, 22, "hide_2")
      Bind(*hide, @Events())
      *show = Button( 5, 30, 55, 22, "show_2")
      Disable(*show, 1)
      Bind(*show, @Events())
      
      *c=Container(110,5,150,155, #PB_Container_Flat) 
      Define *p = Panel(10,5,150,65) 
      AddItem(*p, -1, "item-1")
      Container(10,5,150,55, #PB_Container_Flat) 
      Container(10,5,150,55, #PB_Container_Flat) 
      Button(10,5,50,25, "butt1") 
      CloseList()
      CloseList()
      AddItem(*p, -1, "item-2")
      Container(10,5,150,55, #PB_Container_Flat) 
      Container(10,5,150,55, #PB_Container_Flat) 
      Button(10,5,50,25, "butt2") 
      CloseList()
      CloseList()
      CloseList()
  
      Container(10,75,150,55, #PB_Container_Flat) 
      Container(10,5,150,55, #PB_Container_Flat) 
      Container(10,5,150,55, #PB_Container_Flat) 
      Button(10,5,50,45, "butt1") 
      CloseList()
      CloseList()
      CloseList()
      CloseList()
      
      AddItem(*w1, -1, "Под-Панель 3")
      ;       Bind(@Events(), Button( 5, 5, 55, 22,"hide_3"))
      ;       Bind(@Events(), Button( 5, 30, 55, 22,"show_3"))
      
      *s=Splitter(110, 5, 300, 152, Splitter(5, 5, 300, 152, Button(0,0,0,0, "кнопка 12"), 
      Button(0,0,0,0, "кнопка 13")), Button(0,0,0,0, "кнопка 14"), #PB_Splitter_Vertical) 
      
      AddItem(*w1, -1, "Под-Панель 4")
      
      *w2=Panel (5, 30, 340, 166)
      AddItem(*w2, -1, "Под--Панель 1")
      AddItem(*w2, -1, "Под--Панель 2")
      Button( 5, 5, 80, 22, "кнопка 25")
      Button( 5, 30, 80, 22, "кнопка 30")
      AddItem(*w2, -1, "Под--Панель 3")
      AddItem(*w2, -1, "Под--Панель 4")
      AddItem(*w2, 1, "Под--Панель -2-")
      Button( 15, 5, 80, 22, "кнопка 15")
      Button( 20, 30, 80, 22, "кнопка 20")
      CloseList()
      SetState(*w2, 4)
      
      AddItem(*w1, -1, "Под-Панель 5")
      
      CloseList()
      
      Button(5, 5, 80, 22,"кнопка 5")
      
      AddItem (*w, -1,"Панель 2")
      Button(10, 15, 80, 24,"Кнопка 1")
      Button(95, 15, 80, 24,"Кнопка 2")
      CloseList()
      
      ;       Bind(@Events(), *w)
      ;       Bind(@Events(), *w1)
      ;       Bind(@Events(), *w2)
      SetState(*w1, 3)
      
      
      
    Repeat
      Define Event = WaitWindowEvent()
    Until Event= #PB_Event_CloseWindow
    
  EndIf   
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 53
; FirstLine = 33
; Folding = --
; EnableXP
; DPIAware