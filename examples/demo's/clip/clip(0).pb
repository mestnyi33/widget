XIncludeFile "../../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseWidgets( )
  test_scrollbars_reclip = 1
  
  Global *object._s_WIDGET
  Global *parent._s_WIDGET
  
  If Open( 1, 150, 150, 649, 441, "button - draw parent-inner-clip coordinate", #__Window_SizeGadget | #__Window_SystemMenu)
    a_init( root( ) )
    Define scrollstep = mouse( )\steps
    
    ;*parent = ScrollArea(30,30,450-2,250-2, 200,750, scrollstep, #__flag_nogadgets)
    *parent = Tree(30,30,450-2,250-2) : Define i : For i=0 To 15 : AddItem(*parent, -1,Str(i)+ "_item") : Next : AddItem(*parent, -1,Str(i)+ "_item ertgryeratserysrtysrtyrttretrxvcsdfgdsfgdfgsdfghsfghdfgdfrfasdfsadfasdfgadfgadfsadfddsf")
    
    ReDraw(root())
    
    SetColor(*parent, #__color_back, $C0F2AEDA)
    
    OpenList( *parent )
    *object = Button(50,60,450,250,"button")
    CloseList( )
    ;SetParent(*object, *parent)
    
    ;Debug *parent\width[7]
    
    ;Resize(*object, 40, #PB_Ignore, #PB_Ignore, #PB_Ignore)
    
    WaitClose( )
  EndIf
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 15
; Folding = -
; EnableXP