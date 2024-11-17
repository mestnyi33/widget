

CompilerIf Not Defined( widget, #PB_Module )
  ;-  >>>
  DeclareModule widget
    EnableExplicit
    
    Structure _s_STATE
      *flag     
      hide.b        
      disable.b
      
      enter.b
      press.b
      focus.b
    EndStructure
    Structure _s_TABS 
      state._s_state
    EndStructure
    Structure _s_WIDGET
      *root._s_ROOT
      *tab._s_TABS        
      
      class.s
      List *_s._s_tabs( )
    EndStructure
    Structure _s_ROOT Extends _s_WIDGET
      List *child._s_WIDGET( )    ; widget( )\
    EndStructure
    
    
    ;-
    Macro allocate( _struct_name_, _struct_type_= )
      _S_#_struct_name_#_struct_type_ = AllocateStructure( _S_#_struct_name_ )
    EndMacro
    
    Macro root( ) : *roots( ): EndMacro
    
    
    Global NewMap *roots._s_root() 
    
    Declare   Drawing( )
    
    Declare.i PanelWidget( x.l,y.l,width.l,height.l, Flag.i = 0 )
    Declare   AddItem( *this, Item.l, Text.s, Image.i = -1, flag.i = 0 )
    Declare.i ButtonWidget( x.l,y.l,width.l,height.l, Text.s, Flag.i = 0, Image.i = -1, round.l = 0 )
    Declare   Open( Window, x.l = 0,y.l = 0,width.l = #PB_Ignore,height.l = #PB_Ignore, title$ = #Null$, flag.i = #Null, *callback = #Null, canvas = #PB_Any )
    
    ;}
  EndDeclareModule
  
  Module widget
    
    Procedure   AddItem( *this._S_widget, Item.l, Text.s, Image.i =- 1, flag.i = 0 )
      LastElement( *this\_s( ))
      AddElement( *this\_s( )) 
      *this\_s.allocate(TABS, ( ))
      *this\tab = @*this\_s( ) ; bad
      
      ; *this\tab = *this\_s( ) ; good
      
      Debug "AddItem - "+*this\tab +" "+ *this\_s( ) 
    EndProcedure
    
    Procedure   Drawing( )
      
      Debug "ListSize - "+ListSize(root( )\child( ))
      
      ForEach root( )\child( )
        
        
        Debug root( )\child( )
        Debug "object class - "+root( )\child( )\class
        Debug "class "+root( )\child( )\root\class
        
        
        If root( )\child( )\tab
;           ChangeCurrentElement(Root( )\_s(), Root( )\child( )\tab)
;           Root( )\_s()\state\focus = #False
          root( )\child( )\tab\state\focus = #False
        EndIf
      Next
      
    EndProcedure
    
    
    Procedure.i ButtonWidget( x.l,y.l,width.l,height.l, Text.s, Flag.i = 0, Image.i = -1, round.l = 0 )
      Protected *this.allocate( widget )
      
      *this\class = "button"
      
      If root( )
        LastElement( root( )\child( )  )
        AddElement( root( )\child( )  ) 
        root( )\child( )  = *this
        *this\root = root( )
      EndIf
      
      ProcedureReturn *this
    EndProcedure
    
    Procedure.i PanelWidget( x.l,y.l,width.l,height.l, Flag.i = 0 )
      Protected *this.allocate( widget )
      
      *this\class = "panel"
      
      If root( )
        LastElement( root( )\child( )  )
        AddElement( root( )\child( )  ) 
        root( )\child( )  = *this
        *this\root = root( )
      EndIf
      
      ProcedureReturn *this
    EndProcedure
    
    Procedure   Open( Window, x.l = 0,y.l = 0,width.l = #PB_Ignore,height.l = #PB_Ignore, title$ = #Null$, flag.i = #Null, *CallBack = #Null, Canvas = #PB_Any )
      Protected w, g, UseGadgetList, result
      
      ; get a handle from the previous usage list
      w = WindowID( Window )
      g = CanvasGadget( Canvas, 0, 0, WindowWidth( Window, #PB_Window_InnerCoordinate ),
                        WindowHeight( Window, #PB_Window_InnerCoordinate ), Flag | #PB_Canvas_Keyboard ) 
      If Canvas =- 1 : Canvas = g : g = GadgetID( Canvas ) : EndIf
      
      ;
      If Not FindMapElement( root( ), Str( g ) )
        result = AddMapElement( root( ), Str( g ) )
        root( ) = AllocateStructure( _S_root )
        root( )\class = "root"
        root( )\root = root( )
      EndIf
      
      ProcedureReturn root( )
    EndProcedure
    
    
  EndModule
  ;- <<< 
CompilerEndIf

;- 
Macro UseLIB( _name_ )
  UseModule _name_
EndMacro


CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  
  UseModule widget
  
  Define event
  Define id_design_panel
  
  Open( OpenWindow( #PB_Any, 0,0,0,0, "ide" ) )
  
  ;     ;\\\ 
  id_design_panel = PanelWidget( 0,0,0,0 )
  AddItem( id_design_panel, -1, "Form" )
  ButtonWidget( 0,0,0,0,"" )
  ButtonWidget( 0,0,0,0,"" )
  Drawing()
  
  Repeat 
    event = WaitWindowEvent( ) 
  Until event = #PB_Event_CloseWindow
CompilerEndIf


; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 64
; FirstLine = 61
; Folding = ----
; EnableXP