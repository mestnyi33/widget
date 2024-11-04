XIncludeFile "../../../widgets.pbi" 
UseWidgets( )

Global i, *w, *p1,*p2, *ch, *b, *bb._s_widget

Procedure events_widgets( )
  Select WidgetEvent( )
    Case #__Event_LeftClick
      If *b = EventWidget( )
        If i 
          SetParent(*w, *p2)
        Else
          SetParent(*w, *p1)
        EndIf
        
        Debug ""+GetParent(*w) +" "+ *w +" "+ GetParent(*ch) +" "+  WidgetY(*ch) +" "+  WidgetY(*ch, 3)
        
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
  
  
  *b=Button(10,430, 200, 30, "change parent", #__flag_ButtonToggle) : SetData(*b, 8) 
  
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
  ForEach widgets( )
    If widgets( )\parent
      If widgets( )\before\widget
        before = Str( widgets( )\before\widget\data )
      EndIf
      If widgets( )\after\widget
        after = Str( widgets( )\after\widget\data )
      Else
        after = "  "
      EndIf
      
      If widgets( )\last\widget
        last = Str( widgets( )\last\widget\data )
      Else
        last = "  "
      EndIf
      
      parent = Str( widgets( )\parent\data )
      If widgets( )\parent\first\widget
        parentfirst = Str( widgets( )\parent\first\widget\data )
      EndIf
      If widgets( )\parent\last\widget
        parentlast = Str( widgets( )\parent\last\widget\data )
      EndIf
    
    If widgets( )\first\widget
      first = Str( widgets( )\first\widget\data )
    EndIf
    
    Debug  " "+ parentfirst +" ||<< "+ first + " |<< " + before +" << "+ widgets( )\data +" >> "+ after +" >>| "+ last +" >>|| "+ parentlast +" - "+ Root()\data +" - "+ parent
     Else
      Debug " "+widgets( )\data +" - "+ widgets( )\x +" "+ widgets( )\width
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
  ForEach widgets( )
    If widgets( )\parent
      If widgets( )\before\widget
        before = Str( widgets( )\before\widget\data )
      EndIf
      If widgets( )\after\widget
        after = Str( widgets( )\after\widget\data )
      Else
        after = "  "
      EndIf
      
      If widgets( )\last\widget
        last = Str( widgets( )\last\widget\data )
      Else
        last = "  "
      EndIf
      
      parent = Str( widgets( )\parent\data )
      If widgets( )\parent\first\widget
      parentfirst = Str( widgets( )\parent\first\widget\data )
    EndIf
    If widgets( )\parent\last\widget
      parentlast = Str( widgets( )\parent\last\widget\data )
    EndIf 
    
    If widgets( )\first\widget
      first = Str( widgets( )\first\widget\data )
    EndIf
    
    Debug  " "+ parentfirst +" ||<< "+ first + " |<< " + before +" << "+ widgets( )\data +" >> "+ after +" >>| "+ last +" >>|| "+ parentlast +" - "+ Root()\data +" - "+ parent
     Else
      Debug " "+widgets( )\data +" - "+ widgets( )\x +" "+ widgets( )\width
    EndIf
     
  Next
  
  Bind(*b, @events_widgets())
  
  WaitClose( )
  ; Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 140
; FirstLine = 119
; Folding = ----
; EnableXP
; DPIAware