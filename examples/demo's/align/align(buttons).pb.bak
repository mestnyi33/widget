IncludePath "../../../"
XIncludeFile "widgets.pbi"

DeclareModule AnchorBox
  EnableExplicit
  
  Declare Create(x,y,width,height)
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
         BUTTON
  
  Global size = 16
  Global radius = 7
  
  Procedure Events( )
    
    Select widget::WidgetEvent( )
      Case constants::#__event_Left2Click 
        
      Case constants::#__event_LeftClick 
        Protected *this = widget::EventWidget( )
        
        If *this = BUTTON 
          Protected a = widget::GetData(*this)
          widget::Hide(a, Bool( Not widget::GetState(*this)))
          widget::Resize(a, widget::WidgetX(*this), widget::WidgetY(*this)+widget::WidgetHeight(*this), #PB_Ignore, #PB_Ignore )
          ; widget::Display(a, *this)
        Else
          ;\\
          If *this <> CENTER ; center 
            widget::SetState(CENTER, 0) 
          EndIf
          
          If *this <> LBUTTON And 
             *this <> TBUTTON And 
             *this <> RBUTTON And 
             *this <> BBUTTON
            
            widget::SetState(LBUTTON, 0); left  
            widget::SetState(TBUTTON, 0); top  
            widget::SetState(RBUTTON, 0); right  
            widget::SetState(BBUTTON, 0); bottom  
          EndIf
          
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
          
          ;\\
          Protected LTBUTTON_State = widget::GetState(LTBUTTON)
          Protected LBUTTON_State = widget::GetState(LBUTTON)
          Protected RTBUTTON_State = widget::GetState(RTBUTTON)
          Protected TBUTTON_State = widget::GetState(TBUTTON)
          Protected CENTER_State = widget::GetState(CENTER)
          Protected RBUTTON_State = widget::GetState(RBUTTON)
          Protected LBBUTTON_State = widget::GetState(LBBUTTON)
          Protected BBUTTON_State = widget::GetState(BBUTTON)
          Protected RBBUTTON_State = widget::GetState(RBBUTTON)
          
          ;\\
          Protected x = widget::WidgetX( CENTER, constants::#__c_container ) - size / 2
          Protected width  = widget::WidgetX( RBUTTON, constants::#__c_container ) - size
          
          Protected y = widget::WidgetY( CENTER, constants::#__c_container ) - size / 2
          Protected height = widget::WidgetY( BBUTTON, constants::#__c_container ) - size
          
          ;\\
          If LBUTTON_State And TBUTTON_State And RBUTTON_State And BBUTTON_State
            widget::Resize(DBUTTON, size, size, width, height)
            widget::SetText(BUTTON, "FULL")
            
          ElseIf LTBUTTON_State Or (LBUTTON_State And TBUTTON_State And RBUTTON_State=0 And BBUTTON_State=0)
            widget::Resize(DBUTTON, size, size, size*2, size*2)
            widget::SetText(BUTTON, "LEFT&TOP")
          ElseIf RTBUTTON_State ;Or (LBUTTON_State=0 And TBUTTON_State And RBUTTON_State And BBUTTON_State=0)
            widget::Resize(DBUTTON, width - size, size, size*2, size*2)
            widget::SetText(BUTTON, "TOP&RIGHT")
          ElseIf RBBUTTON_State Or (LBUTTON_State=0 And TBUTTON_State=0 And RBUTTON_State And BBUTTON_State)
            widget::Resize(DBUTTON, width - size, height - size, size*2, size*2)
            widget::SetText(BUTTON, "RIGHT&BOTTOM")
          ElseIf LBBUTTON_State Or (LBUTTON_State And TBUTTON_State=0 And RBUTTON_State=0 And BBUTTON_State)
            widget::Resize(DBUTTON, size, height - size, size*2, size*2)
            widget::SetText(BUTTON, "BOTTOM&LEFT")
            
          ElseIf LBUTTON_State And TBUTTON_State And BBUTTON_State
            widget::Resize(DBUTTON, size, size, size*2, height)
            widget::SetText(BUTTON, "FULLLEFT")
          ElseIf LBUTTON_State And TBUTTON_State And RBUTTON_State
            widget::Resize(DBUTTON, size, size, width, size*2)
            widget::SetText(BUTTON, "FULLTOP")
          ElseIf TBUTTON_State And RBUTTON_State And BBUTTON_State
            widget::Resize(DBUTTON, width - size, size, size*2, height)
            widget::SetText(BUTTON, "FULLRIGHT")
          ElseIf LBUTTON_State And RBUTTON_State And BBUTTON_State
            widget::Resize(DBUTTON, size, height - size, width, size*2)
            widget::SetText(BUTTON, "FULLBOTTOM")
            
          ElseIf LBUTTON_State And RBUTTON_State
            widget::Resize(DBUTTON, size, y, width, size*2)
            widget::SetText(BUTTON, "LEFT&RIGHT")
          ElseIf TBUTTON_State And BBUTTON_State
            widget::Resize(DBUTTON, x, size, size*2, height)
            widget::SetText(BUTTON, "TOP&BOTTOM")
            
          ElseIf LBUTTON_State
            widget::Resize(DBUTTON, size, y, size*2, size*2)
            widget::SetText(BUTTON, "LEFT")
          ElseIf TBUTTON_State
            widget::Resize(DBUTTON, x, size, size*2, size*2)
            widget::SetText(BUTTON, "TOP")
          ElseIf RBUTTON_State
            widget::Resize(DBUTTON, width - size, y, size*2, size*2)
            widget::SetText(BUTTON, "RIGHT")
          ElseIf BBUTTON_State
            widget::Resize(DBUTTON, x, height - size, size*2, size*2)
            widget::SetText(BUTTON, "BOTTOM")
            
          Else
            If Not CENTER_State And *this = CENTER 
              widget::Resize(DBUTTON, size, size, width, height)
              widget::SetText(BUTTON, "FULL")
              widget::SetState(LBUTTON, 1) ; left
              widget::SetState(TBUTTON, 1) ; top
              widget::SetState(RBUTTON, 1) ; right
              widget::SetState(BBUTTON, 1) ; bottom
            Else
              widget::Resize(DBUTTON, x, y, size*2, size*2)
              widget::SetText(BUTTON, "CENTER")
            EndIf
          EndIf
        EndIf
    EndSelect
    
    ProcedureReturn #PB_Ignore
  EndProcedure
  
  Procedure Create(x,y,width,height)
    Protected width1 = width-size*2; -2
    Protected box_height = width/2
    Protected height1 = box_height-size*2 ; -2
    Protected fs = 1
     
    BUTTON = widget::Button(x,y,width, height, "LEFT&TOP",constants::#__button_toggle);,-1,radius)
    
    Protected *a.Structures::_s_widget = widget::Container(0,0,width,box_height)         ;, constants::#__flag_child)
   ;widget::SetFrame(a,fs)
    height1 - fs*2
    width1 - fs*2
    Protected x1 = size + width1
    Protected y1 = size + height1
    DBUTTON = widget::Button(size, size, size*2, size*2, "",0,-1,radius)
    
    LBUTTON = widget::Button(0, 0, size, size, "",constants::#__button_toggle,-1,radius)
    LTBUTTON = widget::Button(0, 0, size, size, "",constants::#__button_toggle,-1,radius)
    TBUTTON = widget::Button(0, 0, size, size, "",constants::#__button_toggle,-1,radius)
    
    RTBUTTON = widget::Button(0, 0, size, size, "",constants::#__button_toggle,-1,radius)
    RBUTTON = widget::Button(0, 0, size, size, "",constants::#__button_toggle,-1,radius)
    RBBUTTON = widget::Button(0, 0, size, size, "",constants::#__button_toggle,-1,radius)
    
    BBUTTON = widget::Button(0, 0, size, size, "",constants::#__button_toggle,-1,radius)
    LBBUTTON = widget::Button(0, 0, size, size, "",constants::#__button_toggle,-1,radius)
    CENTER = widget::Button(0, 0, size, size, "",constants::#__button_toggle,-1,radius)
    
    
    ;widget::SetAlignment( button_full, #__align_full, 0,0,0,0)
    widget::SetAlignment( LBUTTON, constants::#__align_auto, 1,0,0,0)
    widget::SetAlignment( TBUTTON, constants::#__align_auto, 0,1,0,0)
    widget::SetAlignment( RBUTTON, constants::#__align_auto, 0,0,1,0)
    widget::SetAlignment( BBUTTON, constants::#__align_auto, 0,0,0,1)
    widget::SetAlignment( CENTER, constants::#__align_center, 0,0,0,0)
    widget::SetAlignment( LTBUTTON, constants::#__align_auto, 1,1,0,0)
    widget::SetAlignment( RTBUTTON, constants::#__align_auto, 0,1,1,0)
    widget::SetAlignment( RBBUTTON, constants::#__align_auto, 0,0,1,1)
    widget::SetAlignment( LBBUTTON, constants::#__align_auto, 1,0,0,1)
    
    ;widget::SetState( LBUTTON,1 )
    widget::SetState( LTBUTTON,1 )
    ;widget::SetState( TBUTTON,1 )
    widget::CloseList( )
    
    ;widget::setColor(a, constants::#__color_back, widget::GetColor( widget::GetParent( a ), constants::#__color_back) )
    
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
    widget::SetData(BUTTON, *a)
    widget::Bind(BUTTON, @Events( ), constants::#__event_LeftClick )
    
    ProcedureReturn *a
  EndProcedure
EndModule


CompilerIf #PB_Compiler_IsMainFile
  If widget::Open( #PB_Any, 0, 0, 222+222, 205+70+100, "Buttons on the canvas", #PB_Window_SystemMenu | #PB_Window_ScreenCentered ) 
    
    AnchorBox::Create(30,30,250,30)
    
  EndIf
  
  widget::WaitClose( )
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 29
; FirstLine = 27
; Folding = ----
; EnableXP
; DPIAware