IncludePath "../../../"
XIncludeFile "widgets.pbi"

DeclareModule AnchorBox
   EnableExplicit
   
   Declare Create(X,Y,Width,Height)
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
          DBUTTON,
          Button
   
   Global size = 16
   Global radius = 7
   
   Procedure Events( )
      
      Select widget::WidgetEvent( )
         Case constants::#__event_Left2Click 
            
         Case constants::#__event_LeftClick 
            Protected *this = widget::EventWidget( )
            
            If *this = Button 
               Protected a = widget::GetData(*this)
               widget::Hide(a, Bool( Not widget::GetState(*this)))
               widget::Resize(a, widget::X(*this), widget::Y(*this)+widget::Height(*this), #PB_Ignore, #PB_Ignore )
               ; widget::Display(a, *this)
            Else
               Static FULL_state 
               
               If *this = DBUTTON 
                  widget::SetState(DBUTTON, 0)
               Else
                  ;\\
                  If *this = CENTER ; center 
                     If widget::GetState(*this) 
                        FULL_state = 0
                        widget::SetState(DBUTTON, 0) 
                        
                        widget::Hide(LTBUTTON, 0) 
                        widget::Hide(RTBUTTON, 0) 
                        widget::Hide(LBBUTTON, 0)  
                        widget::Hide(RBBUTTON, 0) 
                        
                     Else
                        FULL_state = 1
                        widget::SetState(DBUTTON, 1) 
                        
                        widget::Hide(LTBUTTON, 1) 
                        widget::Hide(RTBUTTON, 1) 
                        widget::Hide(LBBUTTON, 1)  
                        widget::Hide(RBBUTTON, 1) 
                        
                     EndIf
                  Else
                     widget::SetState(CENTER, 0) 
                  EndIf
                  
                  If Not FULL_state
                     If *this = LTBUTTON ; left & top 
                     Else
                        widget::SetState(LTBUTTON, 0) 
                     EndIf
                     
                     If *this = RTBUTTON ; right & top 
                     Else
                        widget::SetState(RTBUTTON, 0) 
                     EndIf
                     
                     If *this = LBBUTTON ; left & bottom 
                     Else
                        widget::SetState(LBBUTTON, 0) 
                     EndIf
                     
                     If *this = RBBUTTON ; right & bottom 
                     Else
                        widget::SetState(RBBUTTON, 0) 
                     EndIf
                  EndIf
                  
                  If *this = LBUTTON 
                  Else
                     widget::SetState(LBUTTON, 0) 
                  EndIf
                  
                  If *this = TBUTTON 
                  Else
                     widget::SetState(TBUTTON, 0) 
                  EndIf
                  
                  If *this = RBUTTON 
                  Else
                     widget::SetState(RBUTTON, 0) 
                  EndIf
                  
                  If *this = BBUTTON 
                  Else
                     widget::SetState(BBUTTON, 0) 
                  EndIf
               EndIf
               
               ;\\
               Protected LTBUTTON_State = widget::GetState(LTBUTTON)
               Protected RTBUTTON_State = widget::GetState(RTBUTTON)
               Protected LBBUTTON_State = widget::GetState(LBBUTTON)
               Protected RBBUTTON_State = widget::GetState(RBBUTTON)
               
               Protected LBUTTON_State = widget::GetState(LBUTTON)
               Protected TBUTTON_State = widget::GetState(TBUTTON)
               Protected RBUTTON_State = widget::GetState(RBUTTON)
               Protected BBUTTON_State = widget::GetState(BBUTTON)
               Protected CENTER_State = widget::GetState(CENTER)
               
               If FULL_state
                  If *this = LBUTTON 
                     TBUTTON_State = 1
                     BBUTTON_State = 1
                  EndIf
                  
                  If *this = TBUTTON 
                     LBUTTON_State = 1
                     RBUTTON_State = 1
                  EndIf
                  
                  If *this = RBUTTON 
                     TBUTTON_State = 1
                     BBUTTON_State = 1
                  EndIf
                  
                  If *this = BBUTTON 
                     LBUTTON_State = 1
                     RBUTTON_State = 1
                  EndIf
               EndIf
               
               ;\\
               Protected X = widget::X( CENTER, constants::#__c_container ) - size / 2
               Protected Width  = widget::X( RBUTTON, constants::#__c_container ) - size
               
               Protected Y = widget::Y( CENTER, constants::#__c_container ) - size / 2
               Protected Height = widget::Y( BBUTTON, constants::#__c_container ) - size
               
               ;\\
               If LBUTTON_State And TBUTTON_State And RBUTTON_State And BBUTTON_State
                  widget::Resize(DBUTTON, size, size, Width, Height)
                  widget::SetText(Button, "FULL")
                  
               ElseIf LTBUTTON_State Or (LBUTTON_State And TBUTTON_State And RBUTTON_State=0 And BBUTTON_State=0)
                  widget::Resize(DBUTTON, size, size, size*2, size*2)
                  widget::SetText(Button, "LEFT&TOP")
               ElseIf RTBUTTON_State ;Or (LBUTTON_State=0 And TBUTTON_State And RBUTTON_State And BBUTTON_State=0)
                  widget::Resize(DBUTTON, Width - size, size, size*2, size*2)
                  widget::SetText(Button, "TOP&RIGHT")
               ElseIf RBBUTTON_State Or (LBUTTON_State=0 And TBUTTON_State=0 And RBUTTON_State And BBUTTON_State)
                  widget::Resize(DBUTTON, Width - size, Height - size, size*2, size*2)
                  widget::SetText(Button, "RIGHT&BOTTOM")
               ElseIf LBBUTTON_State Or (LBUTTON_State And TBUTTON_State=0 And RBUTTON_State=0 And BBUTTON_State)
                  widget::Resize(DBUTTON, size, Height - size, size*2, size*2)
                  widget::SetText(Button, "BOTTOM&LEFT")
                  
               ElseIf LBUTTON_State And TBUTTON_State And BBUTTON_State
                  widget::Resize(DBUTTON, size, size, size*2, Height)
                  widget::SetText(Button, "FULLLEFT")
               ElseIf LBUTTON_State And TBUTTON_State And RBUTTON_State
                  widget::Resize(DBUTTON, size, size, Width, size*2)
                  widget::SetText(Button, "FULLTOP")
               ElseIf TBUTTON_State And RBUTTON_State And BBUTTON_State
                  widget::Resize(DBUTTON, Width - size, size, size*2, Height)
                  widget::SetText(Button, "FULLRIGHT")
               ElseIf LBUTTON_State And RBUTTON_State And BBUTTON_State
                  widget::Resize(DBUTTON, size, Height - size, Width, size*2)
                  widget::SetText(Button, "FULLBOTTOM")
                  
               ElseIf LBUTTON_State And RBUTTON_State
                  widget::Resize(DBUTTON, size, Y, Width, size*2)
                  widget::SetText(Button, "LEFT&RIGHT")
               ElseIf TBUTTON_State And BBUTTON_State
                  widget::Resize(DBUTTON, X, size, size*2, Height)
                  widget::SetText(Button, "TOP&BOTTOM")
                  
               ElseIf LBUTTON_State
                  widget::Resize(DBUTTON, size, Y, size*2, size*2)
                  widget::SetText(Button, "LEFT")
               ElseIf TBUTTON_State
                  widget::Resize(DBUTTON, X, size, size*2, size*2)
                  widget::SetText(Button, "TOP")
               ElseIf RBUTTON_State
                  widget::Resize(DBUTTON, Width - size, Y, size*2, size*2)
                  widget::SetText(Button, "RIGHT")
               ElseIf BBUTTON_State
                  widget::Resize(DBUTTON, X, Height - size, size*2, size*2)
                  widget::SetText(Button, "BOTTOM")
                  
               Else
                  If Not CENTER_State And *this = CENTER 
                     widget::Resize(DBUTTON, size, size, Width, Height)
                     widget::SetText(Button, "FULL")
                  Else
                     widget::Resize(DBUTTON, X, Y, size*2, size*2)
                     widget::SetText(Button, "CENTER")
                     widget::SetState(CENTER, 1)
                  EndIf
               EndIf
            EndIf
      EndSelect
      
      ProcedureReturn #PB_Ignore
   EndProcedure
   
   Procedure Create(X,Y,Width,Height)
      Protected width1 = Width-size*2; -2
      Protected box_height = Width/2
      Protected height1 = box_height-size*2 ; -2
      Protected fs = 1
      
      Button = widget::Button(X,Y,Width, Height, "LEFT&TOP",constants::#__flag_ButtonToggle);,-1,radius)
      
      Protected *a.Structures::_s_widget = widget::Container(0,0,Width,box_height)         ;, constants::#__flag_child)
                                                                                           ;widget::SetFrame(a,fs)
      height1 - fs*2
      width1 - fs*2
      Protected x1 = size + width1
      Protected y1 = size + height1
      DBUTTON = widget::Button(size, size, size*2, size*2, "",constants::#__flag_ButtonToggle,-1,radius)
      
      LBUTTON = widget::Button(0, 0, size, size, "",constants::#__flag_ButtonToggle,-1,radius)
      LTBUTTON = widget::Button(0, 0, size, size, "",constants::#__flag_ButtonToggle,-1,radius)
      TBUTTON = widget::Button(0, 0, size, size, "",constants::#__flag_ButtonToggle,-1,radius)
      
      RTBUTTON = widget::Button(0, 0, size, size, "",constants::#__flag_ButtonToggle,-1,radius)
      RBUTTON = widget::Button(0, 0, size, size, "",constants::#__flag_ButtonToggle,-1,radius)
      RBBUTTON = widget::Button(0, 0, size, size, "",constants::#__flag_ButtonToggle,-1,radius)
      
      BBUTTON = widget::Button(0, 0, size, size, "",constants::#__flag_ButtonToggle,-1,radius)
      LBBUTTON = widget::Button(0, 0, size, size, "",constants::#__flag_ButtonToggle,-1,radius)
      CENTER = widget::Button(0, 0, size, size, "",constants::#__flag_ButtonToggle,-1,radius)
      
      
      ;widget::SetAlign( button_full, #__align_full, 0,0,0,0)
      widget::SetAlign( LBUTTON, constants::#__align_auto, 1,0,0,0)
      widget::SetAlign( TBUTTON, constants::#__align_auto, 0,1,0,0)
      widget::SetAlign( RBUTTON, constants::#__align_auto, 0,0,1,0)
      widget::SetAlign( BBUTTON, constants::#__align_auto, 0,0,0,1)
      widget::SetAlign( CENTER, constants::#__align_center, 0,0,0,0)
      widget::SetAlign( LTBUTTON, constants::#__align_auto, 1,1,0,0)
      widget::SetAlign( RTBUTTON, constants::#__align_auto, 0,1,1,0)
      widget::SetAlign( RBBUTTON, constants::#__align_auto, 0,0,1,1)
      widget::SetAlign( LBBUTTON, constants::#__align_auto, 1,0,0,1)
      
      ;widget::SetState( LBUTTON,1 )
      widget::SetState( LTBUTTON,1 )
      ;widget::SetState( TBUTTON,1 )
      widget::CloseList( )
      
      ;widget::setColor(a, constants::#__color_back, widget::GetColor( widget::GetParent( a ), constants::#__color_back) )
      
      widget::Bind(DBUTTON, @Events( ), constants::#__event_LeftClick )
      widget::Bind(LTBUTTON, @Events( ), constants::#__event_LeftClick )
      widget::Bind(LBUTTON, @Events( ), constants::#__event_LeftClick )
      widget::Bind(RTBUTTON, @Events( ), constants::#__event_LeftClick )
      widget::Bind(TBUTTON, @Events( ), constants::#__event_LeftClick )
      widget::Bind(CENTER, @Events( ), constants::#__event_LeftClick )
      widget::Bind(RBUTTON, @Events( ), constants::#__event_LeftClick )
      widget::Bind(RBBUTTON, @Events( ), constants::#__event_LeftClick )
      widget::Bind(BBUTTON, @Events( ), constants::#__event_LeftClick )
      widget::Bind(LBBUTTON, @Events( ), constants::#__event_LeftClick )
      
      widget::Bind(LTBUTTON, @Events( ), constants::#__event_Left2Click )
      widget::Bind(LBUTTON, @Events( ), constants::#__event_Left2Click )
      widget::Bind(RTBUTTON, @Events( ), constants::#__event_Left2Click )
      widget::Bind(TBUTTON, @Events( ), constants::#__event_Left2Click )
      widget::Bind(CENTER, @Events( ), constants::#__event_Left2Click )
      widget::Bind(RBUTTON, @Events( ), constants::#__event_Left2Click )
      widget::Bind(RBBUTTON, @Events( ), constants::#__event_Left2Click )
      widget::Bind(BBUTTON, @Events( ), constants::#__event_Left2Click )
      widget::Bind(LBBUTTON, @Events( ), constants::#__event_Left2Click )
      
      widget::Hide(*a,1)
      widget::SetData(Button, *a)
      widget::Bind(Button, @Events( ), constants::#__event_LeftClick )
      
      ProcedureReturn *a
   EndProcedure
EndModule


CompilerIf #PB_Compiler_IsMainFile
   If widget::Open( #PB_Any, 0, 0, 222+222, 205+70+100, "Buttons on the canvas", #PB_Window_SystemMenu | #PB_Window_ScreenCentered ) 
      ;widget::a_init(widget::root())
      
      AnchorBox::Create(30,30,250,30)
      
   EndIf
   
   widget::WaitClose( )
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 299
; FirstLine = 205
; Folding = f8---
; EnableXP
; DPIAware