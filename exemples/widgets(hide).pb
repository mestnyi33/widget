IncludePath "../"
XIncludeFile "widgets().pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseModule Widget
  
  Global *c, *s
  
  Procedure Enumerates(*this._S_widget, *callback)
    With *this
      If *callback
        CallCFunctionFast(*callback, *this)
        
        If ListSize(\Childrens())
          ForEach \Childrens()
            Enumerates(\Childrens(), *callback)
          Next
        EndIf
      EndIf
    EndWith
  EndProcedure
  
  Procedure enum(*this._S_widget)
    If Not *this\hide
      Debug " class - " + *this\Class +" ("+ *this\tab\index +" - parent_item)"
    EndIf
  EndProcedure
  
  Procedure Events()
    Select *event\type
      Case #PB_EventType_LeftButtonDown
        
        Select GetText(*event\widget)
          Case "hide_2"
            hide(*c, 1)
            ; Disable(*c, 1)
            
          Case "show_2" 
            hide(*c, 0)
            
          Case "hide_3"
            hide(*s, 1)
            
          Case "show_3" 
            hide(*s, 0)
          
        EndSelect
        
     Case #PB_EventType_LeftButtonUp
        ClearDebugOutput()
        Enumerates(root(), @enum())
        
     Case #PB_EventType_Change
         Debug "hide c - "+hide(*c)+" s - "+hide(*s)
        
    EndSelect
  EndProcedure
  
  
  If OpenWindow(3, 0, 0, 455, 305, "hide/show widgets", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    If Open(3, 0, 0, 455, 605, "window")
      Define *w,*w1,*w2
      
      *w=Panel     (8, 8, 356, 203)
      AddItem (*w, -1, "Панель 1")
      
      *w1=Panel (5, 30, 340, 166)
      AddItem(*w1, -1, "Под-Панель 1")
      
      Tree(5, 5, 180, 100, #PB_Flag_Checkboxes|#PB_Tree_ThreeState)
      
      Define i
      For i=0 To 20
        If i=3
          AddItem(Widget(), i, "long_long_long_item_"+ Str(i),-1, Bool(i=3 Or i=6))
        Else
          AddItem(Widget(), i, "item_"+ Str(i))
        EndIf
      Next
      
      AddItem(*w1, -1, "Под-Панель 2")
      Bind(@Events(), Button( 5, 5, 55, 22, "hide_2"))
      Bind(@Events(), Button( 5, 30, 55, 22, "show_2"))
      
      *c=Container(110,5,150,155, #PB_Container_Flat) 
      Container(10,5,150,55, #PB_Container_Flat) 
      Container(10,5,150,55, #PB_Container_Flat) 
      Container(10,5,150,55, #PB_Container_Flat) 
      Button(10,5,50,35, "butt") 
      CloseList()
      CloseList()
      CloseList()
      
      Container(10,75,150,55, #PB_Container_Flat) 
      Container(10,5,150,55, #PB_Container_Flat) 
      Container(10,5,150,55, #PB_Container_Flat) 
      Button(10,5,50,35, "butt1") 
      CloseList()
      CloseList()
      CloseList()
      CloseList()
      
      AddItem(*w1, -1, "Под-Панель 3")
      ;       Bind(@Events(), Button( 5, 5, 55, 22,"hide_3"))
      ;       Bind(@Events(), Button( 5, 30, 55, 22,"show_3"))
      
      *s=Splitter(110, 5, 300, 152, Splitter(5,5, 300, 152, Button(0, 0, 0, 0,"кнопка 15"), 
      Button(0, 0, 0, 0,"кнопка 15")), Button(0, 0, 0, 0,"кнопка 15"), #PB_Splitter_Vertical) 
      
      AddItem(*w1, -1, "Под-Панель 4")
      
      *w2=Panel (5, 30, 340, 166)
      AddItem(*w2, -1, "Под--Панель 1")
      AddItem(*w2, -1, "Под--Панель 2")
      Button( 5, 5, 55, 22, "кнопка 5")
      Button( 5, 30, 55, 22, "кнопка 30")
      AddItem(*w2, -1, "Под--Панель 3")
      AddItem(*w2, -1, "Под--Панель 4")
      AddItem(*w2, 1, "Под--Панель -2-")
      Button( 15, 5, 55, 22, "кнопка 15")
      Button( 20, 30, 55, 22, "кнопка 20")
      CloseList()
      SetState(*w2, 3)
      
      
      CloseList()
      
      Button(5, 5, 55, 22,"кнопка 5")
      
      AddItem (*w, -1,"Панель 2")
      Button(10, 15, 80, 24,"Кнопка 1")
      Button(95, 15, 80, 24,"Кнопка 2")
      CloseList()
      
      ;       Bind(@Events(), *w)
      ;       Bind(@Events(), *w1)
      ;       Bind(@Events(), *w2)
      
      ReDraw(Root())
    EndIf
    
    Repeat
      Define Event = WaitWindowEvent()
    Until Event= #PB_Event_CloseWindow
    
  EndIf   
CompilerEndIf
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = 0--
; EnableXP