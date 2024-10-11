XIncludeFile "../../../widgets.pbi" 
Uselib(widget)

Global i, *w, *p1,*p2, *ch, *b, *bb._s_widget

Procedure events_widgets( )
  Select WidgetEventType( )
    Case #__Event_LeftClick
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
If Open(0, 0, 0, 222, 470, "ButtonGadgets", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  
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
  
  ;ChangeCurrentRoot( Root( )\canvas\address )
  Debug "after " + *bb\after\widget
  
  Debug ""
  ForEach __widgets( )
    If __widgets( )\parent
      If __widgets( )\before\widget
        before = Str( __widgets( )\before\widget\data )
      EndIf
      If __widgets( )\after\widget
        after = Str( __widgets( )\after\widget\data )
      Else
        after = "  "
      EndIf
      
      If __widgets( )\last\widget
        last = Str( __widgets( )\last\widget\data )
      Else
        last = "  "
      EndIf
      
      parent = Str( __widgets( )\parent\data )
      If __widgets( )\parent\first\widget
        parentfirst = Str( __widgets( )\parent\first\widget\data )
      EndIf
      If __widgets( )\parent\last\widget
        parentlast = Str( __widgets( )\parent\last\widget\data )
      EndIf
    
    If __widgets( )\first\widget
      first = Str( __widgets( )\first\widget\data )
    EndIf
    
    Debug  " "+ parentfirst +" ||<< "+ first + " |<< " + before +" << "+ __widgets( )\data +" >> "+ after +" >>| "+ last +" >>|| "+ parentlast +" - "+ Root()\data +" - "+ parent
     Else
      Debug " "+__widgets( )\data +" - "+ __widgets( )\x +" "+ __widgets( )\width
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
  
 ; ChangeCurrentRoot( Root( )\canvas\address )
  Debug "after " + *bb\after\widget
  
  Debug ""
  ForEach __widgets( )
    If __widgets( )\parent
      If __widgets( )\before\widget
        before = Str( __widgets( )\before\widget\data )
      EndIf
      If __widgets( )\after\widget
        after = Str( __widgets( )\after\widget\data )
      Else
        after = "  "
      EndIf
      
      If __widgets( )\last\widget
        last = Str( __widgets( )\last\widget\data )
      Else
        last = "  "
      EndIf
      
      parent = Str( __widgets( )\parent\data )
      If __widgets( )\parent\first\widget
      parentfirst = Str( __widgets( )\parent\first\widget\data )
    EndIf
    If __widgets( )\parent\last\widget
      parentlast = Str( __widgets( )\parent\last\widget\data )
    EndIf 
    
    If __widgets( )\first\widget
      first = Str( __widgets( )\first\widget\data )
    EndIf
    
    Debug  " "+ parentfirst +" ||<< "+ first + " |<< " + before +" << "+ __widgets( )\data +" >> "+ after +" >>| "+ last +" >>|| "+ parentlast +" - "+ Root()\data +" - "+ parent
     Else
      Debug " "+__widgets( )\data +" - "+ __widgets( )\x +" "+ __widgets( )\width
    EndIf
     
  Next
  
  Bind(*b, @events_widgets())
  
  WaitClose( )
  ; Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 5.73 LTS (Windows - x64)
; CursorPosition = 2
; Folding = ----
; EnableXP
; DPIAware