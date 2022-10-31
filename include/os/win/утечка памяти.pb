

CompilerIf Not Defined( Widget, #PB_Module )
  ;-  >>>
  DeclareModule Widget
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
    
    Macro Root( ) : *roots( ): EndMacro
    
    
    Global NewMap *roots._s_root() 
    
    Declare   ReDraw( )
    
    Declare.i Panel( x.l,y.l,width.l,height.l, Flag.i = 0 )
    Declare   AddItem( *this, Item.l, Text.s, Image.i = -1, flag.i = 0 )
    Declare.i Button( x.l,y.l,width.l,height.l, Text.s, Flag.i = 0, Image.i = -1, round.l = 0 )
    Declare   Open( Window, x.l = 0,y.l = 0,width.l = #PB_Ignore,height.l = #PB_Ignore, title$ = #Null$, flag.i = #Null, *callback = #Null, canvas = #PB_Any )
    
    ;}
  EndDeclareModule
  
  Module Widget
    
    Procedure   AddItem( *this._S_widget, Item.l, Text.s, Image.i =- 1, flag.i = 0 )
      LastElement( *this\_s( ))
      AddElement( *this\_s( )) 
      *this\tab = @*this\_s( ) ; bad
      
      ; *this\tab = *this\_s( ) ; good
      
      Debug "AddItem - "+*this\tab +" "+ *this\_s( ) 
    EndProcedure
    
    Procedure   ReDraw( )
      
      Debug "ListSize - "+ListSize(Root( )\child( ))
      
      ForEach Root( )\child( )
        
        
        Debug Root( )\child( )
        Debug "object class - "+Root( )\child( )\class
        Debug "class "+Root( )\child( )\root\class
        
        
        If Root( )\child( )\tab
          Root( )\child( )\tab\state\focus = #False
        EndIf
      Next
      
    EndProcedure
    
    
    Procedure.i Button( x.l,y.l,width.l,height.l, Text.s, Flag.i = 0, Image.i = -1, round.l = 0 )
      Protected *this.allocate( Widget )
      
      *this\class = "button"
      
      If Root( )
        LastElement( Root( )\child( )  )
        AddElement( Root( )\child( )  ) 
        Root( )\child( )  = *this
        *this\root = Root( )
      EndIf
      
      ProcedureReturn *this
    EndProcedure
    
    Procedure.i Panel( x.l,y.l,width.l,height.l, Flag.i = 0 )
      Protected *this.allocate( Widget )
      
      *this\class = "panel"
      
      If Root( )
        LastElement( Root( )\child( )  )
        AddElement( Root( )\child( )  ) 
        Root( )\child( )  = *this
        *this\root = Root( )
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
      If Not FindMapElement( Root( ), Str( g ) )
        result = AddMapElement( Root( ), Str( g ) )
        Root( ) = AllocateStructure( _S_root )
        Root( )\class = "root"
        Root( )\root = Root( )
      EndIf
      
      ProcedureReturn Root( )
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
  
  UseModule Widget
  
  Define event
  Define id_design_panel
  
  Open( OpenWindow( #PB_Any, 0,0,0,0, "ide" ) )
  
  ;     ;\\\ 
  id_design_panel = Panel( 0,0,0,0 )
  AddItem( id_design_panel, -1, "Form" )
  Button( 0,0,0,0,"" )
  Button( 0,0,0,0,"" )
  ReDraw()
  
  Repeat 
    event = WaitWindowEvent( ) 
  Until event = #PB_Event_CloseWindow
CompilerEndIf


; IDE Options = PureBasic 5.72 (Windows - x86)
; FirstLine = 127
; Folding = ----
; EnableXP