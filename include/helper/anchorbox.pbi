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
      Protected *this.Structures::_s_widget = widgets::EventWidget( )
      ;       If *button = widgets::EventWidget( )
      ;          Debug "box "+widgets::ClassFromEvent( widgets::WidgetEvent( )) +" "+ widgets::GetClass( widgets::EventWidget( ))
      ;       EndIf
      
      Select widgets::WidgetEvent( )
         Case constants::#__event_LeftClick 
            If widgets::IsContainer( *this )
               ProcedureReturn #PB_Ignore
            EndIf
            
            If *this = *button
               
               Protected a = *this\menu\parent ; widgets::GetData(*this)
               If a
                  
                  If widgets::GetState(*this)
                     widgets::Hide(a, #False )
                     ;   
                     Define Y = widgets::Y(*this)
                     Debug ""+*this\class +" "+ widgets::Y(*this)+" "+Y
                     
;                      If widgets::GetParent( a ) = widgets::GetParent( *this )
;                         widgets::Resize(a, widgets::X(*this,constants::#__c_container), widgets::Y(*this,constants::#__c_container)+widgets::Height(*this), widgets::Width(*this), widgets::Width(*this) )
;                      Else
;                         Debug ""+widgets::X(*this) +" "+ widgets::Y(*this)
;                         
;                         widgets::Resize(a, widgets::X(*this), widgets::Height(*this), widgets::Width(*this), widgets::Width(*this) )
                        widgets::Resize(a, widgets::X(*this), Y+widgets::Height(*this), widgets::Width(*this), widgets::Width(*this) )
;                      EndIf
                  Else
                     widgets::Hide(a, #True )
                  EndIf
               EndIf
               
            Else
               ;\\
               If CENTER = *this
                  FULL_state = Bool( widgets::GetState( *this ) = 0 )
                  If Not FULL_state
                     widgets::SetText(*button, "CENTER")
                  EndIf
               Else
                  widgets::SetState( CENTER,0 )
               EndIf
               
               ;
               If LTBUTTON = *this
                  FULL_state = Bool( widgets::GetState( *this ) = 0 )
               EndIf
               If RTBUTTON = *this
                  FULL_state = Bool( widgets::GetState( *this ) = 0 )
               EndIf
               If RBBUTTON = *this
                  FULL_state = Bool( widgets::GetState( *this ) = 0 )
               EndIf
               If LBBUTTON = *this
                  FULL_state = Bool( widgets::GetState( *this ) = 0 )
               EndIf
               
               ;
               If CHANGE_state
                  CHANGE_state = 0
                  widgets::SetState( *this,1 )
                  
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
                     widgets::SetState( *this,1 )
                     CHANGE_state = 1
                  Else
                     widgets::SetText(*button, "LEFT&TOP")
                  EndIf
               Else
                  widgets::SetState( LTBUTTON,FULL_state )
               EndIf
               If RTBUTTON = *this
                  If FULL_state
                     widgets::SetState( *this,1 )
                     CHANGE_state = 1
                  Else
                     widgets::SetText(*button, "RIGHT&TOP")
                  EndIf
               Else
                  widgets::SetState( RTBUTTON,FULL_state )
               EndIf
               If RBBUTTON = *this
                  If FULL_state
                     widgets::SetState( *this,1 )
                     CHANGE_state = 1
                  Else
                     widgets::SetText(*button, "RIGHT&BOTTOM")
                  EndIf
               Else
                  widgets::SetState( RBBUTTON,FULL_state )
               EndIf
               If LBBUTTON = *this
                  If FULL_state
                     widgets::SetState( *this,1 )
                     CHANGE_state = 1
                  Else
                     widgets::SetText(*button, "LEFT&BOTTOM")
                  EndIf
               Else
                  widgets::SetState( LBBUTTON,FULL_state )
               EndIf
               
               ;
               If LBUTTON = *this
                  If widgets::GetState(*this) 
                     widgets::SetText(*button, "LEFT")
                  Else
                     widgets::SetState( *this,1 )
                     CHANGE_state = 1
                     widgets::SetState( TBUTTON,0 )
                     widgets::SetState( RTBUTTON,0 )
                     widgets::SetState( RBUTTON,0 )
                     widgets::SetState( RBBUTTON,0 )
                     widgets::SetState( BBUTTON,0 )
                     ;
                     widgets::SetState( LTBUTTON,1 )
                     widgets::SetState( LBBUTTON,1 )
                     widgets::SetText(*button, "FULLLEFT")
                     ProcedureReturn #PB_Ignore
                  EndIf
               Else
                  widgets::SetState( LBUTTON,FULL_state )
               EndIf
               If TBUTTON = *this
                  If widgets::GetState(*this) 
                     widgets::SetText(*button, "TOP")
                  Else
                     widgets::SetState( *this,1 )
                     CHANGE_state = 1
                     widgets::SetState( LBUTTON,0 )
                     widgets::SetState( LBBUTTON,0 )
                     widgets::SetState( RBUTTON,0 )
                     widgets::SetState( RBBUTTON,0 )
                     widgets::SetState( BBUTTON,0 )
                     ;
                     widgets::SetState( LTBUTTON,1 )
                     widgets::SetState( RTBUTTON,1 )
                     widgets::SetText(*button, "FULLTOP")
                     ProcedureReturn #PB_Ignore
                  EndIf
               Else
                  widgets::SetState( TBUTTON,FULL_state )
               EndIf
               If RBUTTON = *this
                  If widgets::GetState(*this) 
                     widgets::SetText(*button, "RIGHT")
                  Else
                     widgets::SetState( *this,1 )
                     CHANGE_state = 1
                     widgets::SetState( TBUTTON,0 )
                     widgets::SetState( LTBUTTON,0 )
                     widgets::SetState( LBUTTON,0 )
                     widgets::SetState( LBBUTTON,0 )
                     widgets::SetState( BBUTTON,0 )
                     ;
                     widgets::SetState( RTBUTTON,1 )
                     widgets::SetState( RBBUTTON,1 )
                     widgets::SetText(*button, "FULLRIGHT")
                     ProcedureReturn #PB_Ignore
                  EndIf
               Else
                  widgets::SetState( RBUTTON,FULL_state )
               EndIf
               If BBUTTON = *this
                  If widgets::GetState(*this) 
                     widgets::SetText(*button, "BOTTOM")
                  Else
                     widgets::SetState( *this,1 )
                     CHANGE_state = 1
                     widgets::SetState( LBUTTON,0 )
                     widgets::SetState( LTBUTTON,0 )
                     widgets::SetState( RBUTTON,0 )
                     widgets::SetState( RTBUTTON,0 )
                     widgets::SetState( TBUTTON,0 )
                     ;
                     widgets::SetState( LBBUTTON,1 )
                     widgets::SetState( RBBUTTON,1 )
                     widgets::SetText(*button, "FULLBOTTOM")
                     ProcedureReturn #PB_Ignore
                  EndIf
               Else
                  widgets::SetState( BBUTTON,FULL_state )
               EndIf
               
               If FULL_state
                  widgets::SetText(*button, "FULL")
               EndIf
               
               If widgets::a_focused( )
                  Select widgets::GetText(*button)
                     Case "LEFT" : widgets::SetAlign(widgets::a_focused( ), 0, 1,0,0,0 )
                     Case "TOP" : widgets::SetAlign(widgets::a_focused( ), 0, 0,1,0,0 )
                     Case "RIGHT" : widgets::SetAlign(widgets::a_focused( ), 0, 0,0,1,0 )
                     Case "BOTTOM" : widgets::SetAlign(widgets::a_focused( ), 0, 0,0,0,1 )
                        
                     Case "LEFT&TOP" : widgets::SetAlign(widgets::a_focused( ), 0, 1,1,0,0 )
                     Case "LEFT&BOTTOM" : widgets::SetAlign(widgets::a_focused( ), 0, 1,0,0,1 )
                     Case "RIGHT&TOP" : widgets::SetAlign(widgets::a_focused( ), 0, 0,1,1,0 )
                     Case "RIGHT&BOTTOM" : widgets::SetAlign(widgets::a_focused( ), 0, 0,0,1,1 )
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
      Protected Flag = constants::#__flag_NoFocus
      
      If *parent
         widgets::OpenList( *parent )
      EndIf
      *Button = widgets::Button(X,Y,Width, Height, "LEFT&TOP",Flag|#PB_Button_Toggle)
      *a = widgets::Container(0,0,size*8,size*8, Flag) 
      widgets::SetBackgroundColor( *a, $A3E9ED )
      ;
      LBUTTON = widgets::Button(0, 0, size, size, "",Flag|#PB_Button_Toggle,radius)
      LTBUTTON = widgets::Button(0, 0, size, size, "",Flag|#PB_Button_Toggle,radius)
      TBUTTON = widgets::Button(0, 0, size, size, "",Flag|#PB_Button_Toggle,radius)
      ;
      RTBUTTON = widgets::Button(0, 0, size, size, "",Flag|#PB_Button_Toggle,radius)
      RBUTTON = widgets::Button(0, 0, size, size, "",Flag|#PB_Button_Toggle,radius)
      RBBUTTON = widgets::Button(0, 0, size, size, "",Flag|#PB_Button_Toggle,radius)
      ;
      BBUTTON = widgets::Button(0, 0, size, size, "",Flag|#PB_Button_Toggle,radius)
      LBBUTTON = widgets::Button(0, 0, size, size, "",Flag|#PB_Button_Toggle,radius)
      CENTER = widgets::Button(0, 0, size, size, "",Flag|#PB_Button_Toggle,radius)
      
      Define pos = - radius
      ;
      widgets::SetAlign( LBUTTON, constants::#__align_auto, pos,0,0,0)
      widgets::SetAlign( TBUTTON, constants::#__align_auto, 0,pos,0,0)
      widgets::SetAlign( RBUTTON, constants::#__align_auto, 0,0,pos,0)
      widgets::SetAlign( BBUTTON, constants::#__align_auto, 0,0,0,pos)
      widgets::SetAlign( CENTER, constants::#__align_center, 0,0,0,0)
      widgets::SetAlign( LTBUTTON, constants::#__align_auto, pos,pos,0,0)
      widgets::SetAlign( RTBUTTON, constants::#__align_auto, 0,pos,pos,0)
      widgets::SetAlign( RBBUTTON, constants::#__align_auto, 0,0,pos,pos)
      widgets::SetAlign( LBBUTTON, constants::#__align_auto, pos,0,0,pos)
      
      ;widgets::SetState( TBUTTON,1 )
      widgets::SetState( LTBUTTON,1 )
      ;widgets::SetState( LBUTTON,1 )
      ;
      widgets::CloseList( )
      If *parent
         ;  widgets::CloseList( )
      EndIf
      
      ;
      *Button\menu\parent = *a
      widgets::Bind(*button, @Events( ) )
      
      widgets::Bind(LTBUTTON, @Events( ) )
      widgets::Bind(LBUTTON, @Events( ) )
      widgets::Bind(RTBUTTON, @Events( ) )
      widgets::Bind(TBUTTON, @Events( ) )
      widgets::Bind(CENTER, @Events( ) )
      widgets::Bind(RBUTTON, @Events( ) )
      widgets::Bind(RBBUTTON, @Events( ) )
      widgets::Bind(BBUTTON, @Events( ) )
      widgets::Bind(LBBUTTON, @Events( ) )
      
      ;             ;
      ;             widgets::Bind(LTBUTTON, @Events( ), constants::#__event_LeftClick )
      ;             widgets::Bind(LBUTTON, @Events( ), constants::#__event_LeftClick )
      ;             widgets::Bind(RTBUTTON, @Events( ), constants::#__event_LeftClick )
      ;             widgets::Bind(TBUTTON, @Events( ), constants::#__event_LeftClick )
      ;             widgets::Bind(CENTER, @Events( ), constants::#__event_LeftClick )
      ;             widgets::Bind(RBUTTON, @Events( ), constants::#__event_LeftClick )
      ;             widgets::Bind(RBBUTTON, @Events( ), constants::#__event_LeftClick )
      ;             widgets::Bind(BBUTTON, @Events( ), constants::#__event_LeftClick )
      ;             widgets::Bind(LBBUTTON, @Events( ), constants::#__event_LeftClick )
      ;             ;
      ;             widgets::Bind(LTBUTTON, @Events( ), constants::#__event_Left2Click )
      ;             widgets::Bind(LBUTTON, @Events( ), constants::#__event_Left2Click )
      ;             widgets::Bind(RTBUTTON, @Events( ), constants::#__event_Left2Click )
      ;             widgets::Bind(TBUTTON, @Events( ), constants::#__event_Left2Click )
      ;             widgets::Bind(CENTER, @Events( ), constants::#__event_Left2Click )
      ;             widgets::Bind(RBUTTON, @Events( ), constants::#__event_Left2Click )
      ;             widgets::Bind(RBBUTTON, @Events( ), constants::#__event_Left2Click )
      ;             widgets::Bind(BBUTTON, @Events( ), constants::#__event_Left2Click )
      ;             widgets::Bind(LBBUTTON, @Events( ), constants::#__event_Left2Click )
      ;       
      ;      ; widgets::Bind(#PB_All, @Events( ) )
      
      ;
      widgets::Hide(*a, #True )
      widgets::SetData(*a, *Button)
      If *parent
         widgets::CloseList( )
         ; widgets::OpenList( widgets::root( ) )
      EndIf
      
      ;
      ProcedureReturn *button
   EndProcedure
EndModule


CompilerIf #PB_Compiler_IsMainFile
   If widgets::Open( #PB_Any, 0, 0, 222+222, 205+70+100, "Buttons on the canvas", #PB_Window_SystemMenu | #PB_Window_ScreenCentered ) 
      ; widgets::a_init(widgets::root())
      
     ; widgets::Container(50,50,300,200)
      widgets::Tree(50,50,300,200)
      AnchorBox::Create(widgets::Widget( ), 30,30,250,30)
      
   EndIf
   
   widgets::WaitClose( )
CompilerEndIf
; IDE Options = PureBasic 6.30 - C Backend (MacOS X - x64)
; CursorPosition = 358
; FirstLine = 342
; Folding = --------
; EnableXP
; DPIAware