XIncludeFile "../../../../widgets.pbi" 
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
        
        Debug ""+GetParent(*w) +" "+ *w +" "+ GetParent(*ch) +" "+  Y(*ch) +" "+  Y(*ch, 3)
        
        i!1
      EndIf
  EndSelect
EndProcedure

; Shows possible flags of ButtonGadget in action...
If Open(0, 0, 0, 222, 470, "ButtonGadgets", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  
  SetData(root( ), 1 )
  *p2 = Container(10, 10, 200, 200) : SetData(*p2, 2 )
  CloseList()
  
  *p1 = Container(20, 180, 200, 200) : SetData(*p1, 3 )
  *bb = Button(-15, 10, 100, 50, "butt" ) : SetData(*bb, 4) 
      *w = Container(10, 20, 100, 100) : SetData(*w, 5 )
        SetData(Container(10, 10, 100, 100), 6 )
           *ch = Button(-25, 10, 100, 20, "Button")  : SetData(*ch, 7 )
        CloseList()
      CloseList()
  CloseList()
  
  
  *b=Button(10,430, 200, 30, "change parent", #PB_Button_Toggle) : SetData(*b, 8) 
  
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
  Debug "after " + *bb\AfterWidget( )
  
  Debug ""
  ForEach widgets( )
    If widgets( )\parent
      If widgets( )\BeforeWidget( )
        before = Str( widgets( )\BeforeWidget( )\data )
      EndIf
      If widgets( )\AfterWidget( )
        after = Str( widgets( )\AfterWidget( )\data )
      Else
        after = "  "
      EndIf
      
      If widgets( )\LastWidget( )
        last = Str( widgets( )\LastWidget( )\data )
      Else
        last = "  "
      EndIf
      
      parent = Str( widgets( )\parent\data )
      If widgets( )\parent\FirstWidget( )
        parentfirst = Str( widgets( )\parent\FirstWidget( )\data )
      EndIf
      If widgets( )\parent\LastWidget( )
        parentlast = Str( widgets( )\parent\LastWidget( )\data )
      EndIf
    
    If widgets( )\FirstWidget( )
      first = Str( widgets( )\FirstWidget( )\data )
    EndIf
    
    Debug  " "+ parentfirst +" ||<< "+ first + " |<< " + before +" << "+ widgets( )\data +" >> "+ after +" >>| "+ last +" >>|| "+ parentlast +" - "+ root()\data +" - "+ parent
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
  Debug "after " + *bb\AfterWidget( )
  
  Debug ""
  ForEach widgets( )
    If widgets( )\parent
      If widgets( )\BeforeWidget( )
        before = Str( widgets( )\BeforeWidget( )\data )
      EndIf
      If widgets( )\AfterWidget( )
        after = Str( widgets( )\AfterWidget( )\data )
      Else
        after = "  "
      EndIf
      
      If widgets( )\LastWidget( )
        last = Str( widgets( )\LastWidget( )\data )
      Else
        last = "  "
      EndIf
      
      parent = Str( widgets( )\parent\data )
      If widgets( )\parent\FirstWidget( )
      parentfirst = Str( widgets( )\parent\FirstWidget( )\data )
    EndIf
    If widgets( )\parent\LastWidget( )
      parentlast = Str( widgets( )\parent\LastWidget( )\data )
    EndIf 
    
    If widgets( )\FirstWidget( )
      first = Str( widgets( )\FirstWidget( )\data )
    EndIf
    
    Debug  " "+ parentfirst +" ||<< "+ first + " |<< " + before +" << "+ widgets( )\data +" >> "+ after +" >>| "+ last +" >>|| "+ parentlast +" - "+ root()\data +" - "+ parent
     Else
      Debug " "+widgets( )\data +" - "+ widgets( )\x +" "+ widgets( )\width
    EndIf
     
  Next
  
  Bind(*b, @events_widgets())
  
  WaitClose( )
  ; Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 135
; FirstLine = 108
; Folding = ----
; EnableXP
; DPIAware