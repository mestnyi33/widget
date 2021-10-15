XIncludeFile "../../../-widgets.pbi" : Uselib(widget)

Global i, *w, *p1,*p2, *ch, *b, *bb._s_widget

Procedure events_widgets( )
  Select WidgetEventType( )
    Case #PB_EventType_LeftClick
      If *b = EventWidget( )
        If i 
          SetParent(*w, *p2)
        Else
          SetParent(*w, *p1)
        EndIf
        
        Debug ""+GetParent(*w) +" "+ *w +" "+ GetParent(*ch) +" "+  Y(*ch) +" "+  Y(*ch, 3)
        
        i!1
      EndIf
  EndSelect
EndProcedure

; Shows possible flags of ButtonGadget in action...
If Open(OpenWindow(#PB_Any, 0, 0, 222, 470, "ButtonGadgets", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)): bind(-1,-1)
  
  SetData(Root( ), 1 )
  *p2 = Container(10, 10, 200, 200) : SetData(*p2, 2 )
  CloseList()
  
  *p1 = Container(20, 180, 200, 200) : SetData(*p1, 3 )
  *bb = button(-15, 10, 100, 50, "butt" ) : SetData(*bb, 4) 
      *w = Container(10, 20, 100, 100) : SetData(*w, 5 )
        SetData(Container(10, 10, 100, 100), 6 )
           *ch = Button(-25, 10, 100, 20, "Button")  : SetData(*ch, 7 )
        CloseList()
      CloseList()
  CloseList()
  
  
  *b=Button(10,430, 200, 30, "change parent", #__Button_Toggle) : SetData(*b, 8) 
  
  i = 1
  
  ;   
  Define parent.s = "  "
  Define first.s = "  "
  Define before.s = "  "
  Define after.s = "  "
  Define last.s = "  "
  Define parentlast.s = "  "
  Define parentfirst.s = "  "
  
  ChangeCurrentRoot( Root( )\root\canvas\address )
  Debug "after " + *bb\after\widget
  
  Debug ""
  ForEach Widget()
    If Widget()\parent\widget
      If Widget()\before\widget
        before = Str( Widget()\before\widget\data )
      EndIf
      If Widget()\after\widget
        after = Str( Widget()\after\widget\data )
      Else
        after = "  "
      EndIf
      
      If Widget()\last\widget
        last = Str( Widget()\last\widget\data )
      Else
        last = "  "
      EndIf
      
      parent = Str( Widget()\parent\widget\data )
      parentfirst = Str( Widget()\parent\widget\first\widget\data )
      parentlast = Str( Widget()\parent\widget\last\widget\data )
      
    
    If Widget()\first\widget
      first = Str( Widget()\first\widget\data )
    EndIf
    
    Debug  " "+ parentfirst +" ||<< "+ first + " |<< " + before +" << "+ Widget()\data +" >> "+ after +" >>| "+ last +" >>|| "+ parentlast +" - "+ Widget()\root\data +" - "+ parent
     Else
      Debug " "+Widget()\data +" - "+ Widget()\x +" "+ Widget()\width
    EndIf
     
  Next
  
  
  SetParent(*w, *p2)
   SetParent(*w, *p1)
  
  ;   
  Define parent.s = "  "
  Define first.s = "  "
  Define before.s = "  "
  Define after.s = "  "
  Define last.s = "  "
  Define parentlast.s = "  "
  Define parentfirst.s = "  "
  
  ChangeCurrentRoot( Root( )\root\canvas\address )
  Debug "after " + *bb\after\widget
  
  Debug ""
  ForEach Widget()
    If Widget()\parent\widget
      If Widget()\before\widget
        before = Str( Widget()\before\widget\data )
      EndIf
      If Widget()\after\widget
        after = Str( Widget()\after\widget\data )
      Else
        after = "  "
      EndIf
      
      If Widget()\last\widget
        last = Str( Widget()\last\widget\data )
      Else
        last = "  "
      EndIf
      
      parent = Str( Widget()\parent\widget\data )
      parentfirst = Str( Widget()\parent\widget\first\widget\data )
      parentlast = Str( Widget()\parent\widget\last\widget\data )
      
    
    If Widget()\first\widget
      first = Str( Widget()\first\widget\data )
    EndIf
    
    Debug  " "+ parentfirst +" ||<< "+ first + " |<< " + before +" << "+ Widget()\data +" >> "+ after +" >>| "+ last +" >>|| "+ parentlast +" - "+ Widget()\root\data +" - "+ parent
     Else
      Debug " "+Widget()\data +" - "+ Widget()\x +" "+ Widget()\width
    EndIf
     
  Next
  
  Bind(#PB_All, @events_widgets())
  
  Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = ---
; EnableXP