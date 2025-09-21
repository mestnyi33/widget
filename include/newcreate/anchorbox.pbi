CompilerIf #PB_Compiler_IsMainFile
   XIncludeFile "../../widgets.pbi"
CompilerEndIf

DeclareModule AnchorBox
   EnableExplicit
   
   Declare Create( *parent, X,Y,Width,Height )
EndDeclareModule

Module AnchorBox
   Global LTBUTTON,
          LBUTTON,
          RTBUTTON,
          TBUTTON,
          CENTER,
          RBUTTON,
          LBBUTTON,
          BBUTTON,
          RBBUTTON,
          *button.Structures::_s_widget
   
   Global size = 16
   Global radius = 7
   Global minsize = 30
   Global CHANGE_state
   Global FULL_state
   
   Procedure Events( )
      Protected *this.Structures::_s_widget = widget::EventWidget( )
      ;       If *button = widget::EventWidget( )
      ;          Debug "box "+widget::ClassFromEvent( widget::WidgetEvent( )) +" "+ widget::GetClass( widget::EventWidget( ))
      ;       EndIf
      
      Select widget::WidgetEvent( )
         Case constants::#__event_LeftClick 
            If widget::IsContainer( *this )
               ProcedureReturn #PB_Ignore
            EndIf
            
            If *this = *button
               
               Protected a = *this\popup\parent ; widget::GetData(*this)
               If a
                  
                  If widget::GetState(*this)
                     widget::Hide(a, #False )
                     ;   
                     Define Y = widget::Y(*this)
                     Debug ""+*this\class +" "+ widget::Y(*this)+" "+Y
                     
;                      If widget::GetParent( a ) = widget::GetParent( *this )
;                         widget::Resize(a, widget::X(*this,constants::#__c_container), widget::Y(*this,constants::#__c_container)+widget::Height(*this), widget::Width(*this), widget::Width(*this) )
;                      Else
;                         Debug ""+widget::X(*this) +" "+ widget::Y(*this)
;                         
;                         widget::Resize(a, widget::X(*this), widget::Height(*this), widget::Width(*this), widget::Width(*this) )
                        widget::Resize(a, widget::X(*this), Y+widget::Height(*this), widget::Width(*this), widget::Width(*this) )
;                      EndIf
                  Else
                     widget::Hide(a, #True )
                  EndIf
               EndIf
               
            Else
               ;\\
               If CENTER = *this
                  FULL_state = Bool( widget::GetState( *this ) = 0 )
                  If Not FULL_state
                     widget::SetText(*button, "CENTER")
                  EndIf
               Else
                  widget::SetState( CENTER,0 )
               EndIf
               
               ;
               If LTBUTTON = *this
                  FULL_state = Bool( widget::GetState( *this ) = 0 )
               EndIf
               If RTBUTTON = *this
                  FULL_state = Bool( widget::GetState( *this ) = 0 )
               EndIf
               If RBBUTTON = *this
                  FULL_state = Bool( widget::GetState( *this ) = 0 )
               EndIf
               If LBBUTTON = *this
                  FULL_state = Bool( widget::GetState( *this ) = 0 )
               EndIf
               
               ;
               If CHANGE_state
                  CHANGE_state = 0
                  widget::SetState( *this,1 )
                  
                  ;                   If LTBUTTON = *this Or 
                  ;                      RTBUTTON = *this Or 
                  ;                      RBBUTTON = *this Or 
                  ;                      LBBUTTON = *this
                  ;                      ;
                  FULL_state = 0
                  ;                   EndIf
               EndIf
               
               ;
               If LTBUTTON = *this
                  If FULL_state
                     widget::SetState( *this,1 )
                     CHANGE_state = 1
                  Else
                     widget::SetText(*button, "LEFT&TOP")
                  EndIf
               Else
                  widget::SetState( LTBUTTON,FULL_state )
               EndIf
               If RTBUTTON = *this
                  If FULL_state
                     widget::SetState( *this,1 )
                     CHANGE_state = 1
                  Else
                     widget::SetText(*button, "RIGHT&TOP")
                  EndIf
               Else
                  widget::SetState( RTBUTTON,FULL_state )
               EndIf
               If RBBUTTON = *this
                  If FULL_state
                     widget::SetState( *this,1 )
                     CHANGE_state = 1
                  Else
                     widget::SetText(*button, "RIGHT&BOTTOM")
                  EndIf
               Else
                  widget::SetState( RBBUTTON,FULL_state )
               EndIf
               If LBBUTTON = *this
                  If FULL_state
                     widget::SetState( *this,1 )
                     CHANGE_state = 1
                  Else
                     widget::SetText(*button, "LEFT&BOTTOM")
                  EndIf
               Else
                  widget::SetState( LBBUTTON,FULL_state )
               EndIf
               
               ;
               If LBUTTON = *this
                  If widget::GetState(*this) 
                     widget::SetText(*button, "LEFT")
                  Else
                     widget::SetState( *this,1 )
                     CHANGE_state = 1
                     widget::SetState( TBUTTON,0 )
                     widget::SetState( RTBUTTON,0 )
                     widget::SetState( RBUTTON,0 )
                     widget::SetState( RBBUTTON,0 )
                     widget::SetState( BBUTTON,0 )
                     ;
                     widget::SetState( LTBUTTON,1 )
                     widget::SetState( LBBUTTON,1 )
                     widget::SetText(*button, "FULLLEFT")
                     ProcedureReturn #PB_Ignore
                  EndIf
               Else
                  widget::SetState( LBUTTON,FULL_state )
               EndIf
               If TBUTTON = *this
                  If widget::GetState(*this) 
                     widget::SetText(*button, "TOP")
                  Else
                     widget::SetState( *this,1 )
                     CHANGE_state = 1
                     widget::SetState( LBUTTON,0 )
                     widget::SetState( LBBUTTON,0 )
                     widget::SetState( RBUTTON,0 )
                     widget::SetState( RBBUTTON,0 )
                     widget::SetState( BBUTTON,0 )
                     ;
                     widget::SetState( LTBUTTON,1 )
                     widget::SetState( RTBUTTON,1 )
                     widget::SetText(*button, "FULLTOP")
                     ProcedureReturn #PB_Ignore
                  EndIf
               Else
                  widget::SetState( TBUTTON,FULL_state )
               EndIf
               If RBUTTON = *this
                  If widget::GetState(*this) 
                     widget::SetText(*button, "RIGHT")
                  Else
                     widget::SetState( *this,1 )
                     CHANGE_state = 1
                     widget::SetState( TBUTTON,0 )
                     widget::SetState( LTBUTTON,0 )
                     widget::SetState( LBUTTON,0 )
                     widget::SetState( LBBUTTON,0 )
                     widget::SetState( BBUTTON,0 )
                     ;
                     widget::SetState( RTBUTTON,1 )
                     widget::SetState( RBBUTTON,1 )
                     widget::SetText(*button, "FULLRIGHT")
                     ProcedureReturn #PB_Ignore
                  EndIf
               Else
                  widget::SetState( RBUTTON,FULL_state )
               EndIf
               If BBUTTON = *this
                  If widget::GetState(*this) 
                     widget::SetText(*button, "BOTTOM")
                  Else
                     widget::SetState( *this,1 )
                     CHANGE_state = 1
                     widget::SetState( LBUTTON,0 )
                     widget::SetState( LTBUTTON,0 )
                     widget::SetState( RBUTTON,0 )
                     widget::SetState( RTBUTTON,0 )
                     widget::SetState( TBUTTON,0 )
                     ;
                     widget::SetState( LBBUTTON,1 )
                     widget::SetState( RBBUTTON,1 )
                     widget::SetText(*button, "FULLBOTTOM")
                     ProcedureReturn #PB_Ignore
                  EndIf
               Else
                  widget::SetState( BBUTTON,FULL_state )
               EndIf
               
               If FULL_state
                  widget::SetText(*button, "FULL")
               EndIf
               
               If widget::a_focused( )
                  Select widget::GetText(*button)
                     Case "LEFT" : widget::SetAlign(widget::a_focused( ), 0, 1,0,0,0 )
                     Case "TOP" : widget::SetAlign(widget::a_focused( ), 0, 0,1,0,0 )
                     Case "RIGHT" : widget::SetAlign(widget::a_focused( ), 0, 0,0,1,0 )
                     Case "BOTTOM" : widget::SetAlign(widget::a_focused( ), 0, 0,0,0,1 )
                        
                     Case "LEFT&TOP" : widget::SetAlign(widget::a_focused( ), 0, 1,1,0,0 )
                     Case "LEFT&BOTTOM" : widget::SetAlign(widget::a_focused( ), 0, 1,0,0,1 )
                     Case "RIGHT&TOP" : widget::SetAlign(widget::a_focused( ), 0, 0,1,1,0 )
                     Case "RIGHT&BOTTOM" : widget::SetAlign(widget::a_focused( ), 0, 0,0,1,1 )
                  EndSelect
               EndIf
               
            EndIf
      EndSelect
      
      If *this <> *button
         ProcedureReturn #PB_Ignore ; no send event
      EndIf
   EndProcedure
   
   Procedure Create( *parent, X,Y,Width,Height )
      Protected *a.Structures::_s_widget 
      Protected flag = constants::#__flag_NoFocus
      
      If *parent
         widget::OpenList( *parent )
      EndIf
      *Button = widget::Button(X,Y,Width, Height, "LEFT&TOP",flag|#PB_Button_Toggle)
      *a = widget::Container(0,0,size*8,size*8, flag) 
      widget::SetBackgroundColor( *a, $A3E9ED )
      ;
      LBUTTON = widget::Button(0, 0, size, size, "",flag|#PB_Button_Toggle,radius)
      LTBUTTON = widget::Button(0, 0, size, size, "",flag|#PB_Button_Toggle,radius)
      TBUTTON = widget::Button(0, 0, size, size, "",flag|#PB_Button_Toggle,radius)
      ;
      RTBUTTON = widget::Button(0, 0, size, size, "",flag|#PB_Button_Toggle,radius)
      RBUTTON = widget::Button(0, 0, size, size, "",flag|#PB_Button_Toggle,radius)
      RBBUTTON = widget::Button(0, 0, size, size, "",flag|#PB_Button_Toggle,radius)
      ;
      BBUTTON = widget::Button(0, 0, size, size, "",flag|#PB_Button_Toggle,radius)
      LBBUTTON = widget::Button(0, 0, size, size, "",flag|#PB_Button_Toggle,radius)
      CENTER = widget::Button(0, 0, size, size, "",flag|#PB_Button_Toggle,radius)
      
      Define pos = - radius
      ;
      widget::SetAlign( LBUTTON, constants::#__align_auto, pos,0,0,0)
      widget::SetAlign( TBUTTON, constants::#__align_auto, 0,pos,0,0)
      widget::SetAlign( RBUTTON, constants::#__align_auto, 0,0,pos,0)
      widget::SetAlign( BBUTTON, constants::#__align_auto, 0,0,0,pos)
      widget::SetAlign( CENTER, constants::#__align_center, 0,0,0,0)
      widget::SetAlign( LTBUTTON, constants::#__align_auto, pos,pos,0,0)
      widget::SetAlign( RTBUTTON, constants::#__align_auto, 0,pos,pos,0)
      widget::SetAlign( RBBUTTON, constants::#__align_auto, 0,0,pos,pos)
      widget::SetAlign( LBBUTTON, constants::#__align_auto, pos,0,0,pos)
      
      ;widget::SetState( TBUTTON,1 )
      widget::SetState( LTBUTTON,1 )
      ;widget::SetState( LBUTTON,1 )
      ;
      widget::CloseList( )
      If *parent
         ;  widget::CloseList( )
      EndIf
      
      ;
      *Button\popup\parent = *a
      widget::Bind(*button, @Events( ) )
      
      widget::Bind(LTBUTTON, @Events( ) )
      widget::Bind(LBUTTON, @Events( ) )
      widget::Bind(RTBUTTON, @Events( ) )
      widget::Bind(TBUTTON, @Events( ) )
      widget::Bind(CENTER, @Events( ) )
      widget::Bind(RBUTTON, @Events( ) )
      widget::Bind(RBBUTTON, @Events( ) )
      widget::Bind(BBUTTON, @Events( ) )
      widget::Bind(LBBUTTON, @Events( ) )
      
      ;             ;
      ;             widget::Bind(LTBUTTON, @Events( ), constants::#__event_LeftClick )
      ;             widget::Bind(LBUTTON, @Events( ), constants::#__event_LeftClick )
      ;             widget::Bind(RTBUTTON, @Events( ), constants::#__event_LeftClick )
      ;             widget::Bind(TBUTTON, @Events( ), constants::#__event_LeftClick )
      ;             widget::Bind(CENTER, @Events( ), constants::#__event_LeftClick )
      ;             widget::Bind(RBUTTON, @Events( ), constants::#__event_LeftClick )
      ;             widget::Bind(RBBUTTON, @Events( ), constants::#__event_LeftClick )
      ;             widget::Bind(BBUTTON, @Events( ), constants::#__event_LeftClick )
      ;             widget::Bind(LBBUTTON, @Events( ), constants::#__event_LeftClick )
      ;             ;
      ;             widget::Bind(LTBUTTON, @Events( ), constants::#__event_Left2Click )
      ;             widget::Bind(LBUTTON, @Events( ), constants::#__event_Left2Click )
      ;             widget::Bind(RTBUTTON, @Events( ), constants::#__event_Left2Click )
      ;             widget::Bind(TBUTTON, @Events( ), constants::#__event_Left2Click )
      ;             widget::Bind(CENTER, @Events( ), constants::#__event_Left2Click )
      ;             widget::Bind(RBUTTON, @Events( ), constants::#__event_Left2Click )
      ;             widget::Bind(RBBUTTON, @Events( ), constants::#__event_Left2Click )
      ;             widget::Bind(BBUTTON, @Events( ), constants::#__event_Left2Click )
      ;             widget::Bind(LBBUTTON, @Events( ), constants::#__event_Left2Click )
      ;       
      ;      ; widget::Bind(#PB_All, @Events( ) )
      
      ;
      widget::Hide(*a, #True )
      widget::SetData(*a, *Button)
      If *parent
         widget::CloseList( )
         ; widget::OpenList( widget::root( ) )
      EndIf
      
      ;
      ProcedureReturn *button
   EndProcedure
EndModule


CompilerIf #PB_Compiler_IsMainFile
   If widget::Open( #PB_Any, 0, 0, 222+222, 205+70+100, "Buttons on the canvas", #PB_Window_SystemMenu | #PB_Window_ScreenCentered ) 
      ; widget::a_init(widget::root())
      
     ; widget::Container(50,50,300,200)
      widget::Tree(50,50,300,200)
      AnchorBox::Create(widget::widget( ), 30,30,250,30)
      
   EndIf
   
   widget::WaitClose( )
CompilerEndIf
; IDE Options = PureBasic 6.20 (Windows - x64)
; CursorPosition = 298
; FirstLine = 294
; Folding = --------
; EnableXP
; DPIAware