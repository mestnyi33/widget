XIncludeFile "../../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseWidgets( )
  ;test_scrollbars_reclip = 1
  ;test_clip = 1
  test_iclip = 1
   
  Global *object._s_WIDGET
  Global *parent._s_WIDGET
  Global scrollstep
  
  Procedure TestOpenList( *parent._s_WIDGET )
     If IsGadget( *parent )
        OpenGadgetList( *parent )
     Else
        OpenList( *parent )
     EndIf
  EndProcedure
  
  Procedure TestCloseList( *parent._s_WIDGET )
     If IsGadget( *parent )
        CloseGadgetList( )
     Else
        CloseList( )
     EndIf
  EndProcedure
  
  Procedure TestSetColor( *this._s_WIDGET, colortype, color )
     If IsGadget( *this )
        SetGadgetColor(*this, colortype, color )
     Else
        SetColor(*this, colortype, color )
     EndIf
  EndProcedure
  
  Procedure TestButton( *parent._s_WIDGET, X,Y,Width,Height, text$ )
     If IsGadget( *parent )
        OpenGadgetList( *parent )
        ButtonGadget( #PB_Any, X,Y,Width,Height, text$ )
        CloseGadgetList( )
     Else
        OpenList( *parent )
        Button(X,Y,Width,Height, text$ )
        CloseList( )
     EndIf
  EndProcedure
  
  Procedure Test( Type )
     Protected._s_WIDGET *g
  
     If Type = #__type_Tree
        *g = Tree(30,30,450-2,250-2) 
        Define i 
        For i = 0 To 15 
           AddItem(*g, -1,Str(i)+ "_item") 
        Next 
        ;AddItem(*g, -1,Str(i)+ "_item ertgryeratserysrtysrtyrttretrxvcsdfgdsfgdfgsdfghsfghdfgdfrfasdfsadfasdfgadfgadfsadfddsf")
     EndIf
     
     If Type = #__type_ScrollArea
        *g = ScrollArea(30,30,450-2,250-2, 100,750, scrollstep, #__flag_nogadgets)
     EndIf
     
     ProcedureReturn *g
  EndProcedure
  
  
  If Open( 1, 150, 150, 649, 441, "button - draw parent-inner-clip coordinate", #PB_Window_SizeGadget | #PB_Window_SystemMenu)
    ;a_init( Root( ) )
    scrollstep = 1;mouse( )\steps
    SetColor(Root( ), #PB_Gadget_BackColor, $C0FDA2AE)
    
    ;*parent = ScrollArea(30,30,450-2,250-2, 200,750, scrollstep) : CloseList( )
    ;*parent = ScrollAreaGadget(#PB_Any, 30,30,450-2,250-2, 200,750, scrollstep ) : CloseGadgetList( )
    *parent = Test(#__type_Tree)
    
    ReDraw(Root())
    
    TestSetColor(*parent, #PB_Gadget_BackColor, $C0F2AEDA)
    
    *object = TestButton(*parent, 50,60,450,250,"button")
    
    If Not IsGadget(*parent)
       Debug ""+*parent\clip_x() +" "+*parent\clip_y() +" "+*parent\clip_width() +" "+*parent\clip_height()
       Debug ""+*parent\clip_ix() +" "+*parent\clip_iy() +" "+*parent\clip_iwidth() +" "+*parent\clip_iheight()
    EndIf
    
    ;Resize(*object, 40, #PB_Ignore, #PB_Ignore, #PB_Ignore)
    
    WaitClose( )
  EndIf
CompilerEndIf
; IDE Options = PureBasic 6.21 - C Backend (MacOS X - x64)
; CursorPosition = 58
; FirstLine = 35
; Folding = V--
; EnableXP