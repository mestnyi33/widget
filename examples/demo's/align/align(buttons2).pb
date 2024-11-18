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
         Button
  
  Global size = 16
  Global radius = 7
  
  Procedure Events( )
    
    Select widget::WidgetEvent( )
      Case constants::#__event_LeftClick 
        Protected *this = widget::EventWidget( )
        
        If *this = Button 
          Protected a = widget::GetWidgetData(*this)
          widget::Hide(a, Bool( Not widget::GetWidgetState(*this)))
          widget::ResizeWidget(a, widget::X(*this), widget::Y(*this)+widget::WidgetHeight(*this), #PB_Ignore, #PB_Ignore )
          ; widget::Display(a, *this)
        Else
          ;\\
          If *this <> CENTER ; center 
            widget::SetWidgetState(CENTER, 0) 
          EndIf
          
          If *this <> LBUTTON And 
             *this <> TBUTTON And 
             *this <> RBUTTON And 
             *this <> BBUTTON
            
            widget::SetWidgetState(LBUTTON, 0); left  
            widget::SetWidgetState(TBUTTON, 0); top  
            widget::SetWidgetState(RBUTTON, 0); right  
            widget::SetWidgetState(BBUTTON, 0); bottom  
          EndIf
          
          If *this = LTBUTTON ; left & top 
            widget::SetWidgetState(LBUTTON, 1) ; left
            widget::SetWidgetState(TBUTTON, 1) ; top
          Else
            widget::SetWidgetState(LTBUTTON, 0) 
          EndIf
          
          If *this = RTBUTTON ; right & top 
            widget::SetWidgetState(TBUTTON, 1) ; top
            widget::SetWidgetState(RBUTTON, 1) ; right
          Else
            widget::SetWidgetState(RTBUTTON, 0) 
          EndIf
          
          If *this = LBBUTTON ; left & bottom 
            widget::SetWidgetState(LBUTTON, 1) ; left
            widget::SetWidgetState(BBUTTON, 1) ; bottom
          Else
            widget::SetWidgetState(LBBUTTON, 0) 
          EndIf
          
          If *this = RBBUTTON ; right & bottom 
            widget::SetWidgetState(RBUTTON, 1) ; right
            widget::SetWidgetState(BBUTTON, 1) ; bottom
          Else
            widget::SetWidgetState(RBBUTTON, 0) 
          EndIf
          
          ;\\
          Protected LTBUTTON_State = widget::GetWidgetState(LTBUTTON)
          Protected LBUTTON_State = widget::GetWidgetState(LBUTTON)
          Protected RTBUTTON_State = widget::GetWidgetState(RTBUTTON)
          Protected TBUTTON_State = widget::GetWidgetState(TBUTTON)
          Protected CENTER_State = widget::GetWidgetState(CENTER)
          Protected RBUTTON_State = widget::GetWidgetState(RBUTTON)
          Protected LBBUTTON_State = widget::GetWidgetState(LBBUTTON)
          Protected BBUTTON_State = widget::GetWidgetState(BBUTTON)
          Protected RBBUTTON_State = widget::GetWidgetState(RBBUTTON)
          
          ;\\
          Protected x = widget::X( CENTER, constants::#__c_container ) - size / 2
          Protected width  = widget::X( RBUTTON, constants::#__c_container ) - size
          
          Protected y = widget::Y( CENTER, constants::#__c_container ) - size / 2
          Protected height = widget::Y( BBUTTON, constants::#__c_container ) - size
          
          ;\\
          If LBUTTON_State And TBUTTON_State And RBUTTON_State And BBUTTON_State
            widget::ResizeWidget(DBUTTON, size, size, width, height)
            widget::SetWidgetText(Button, "FULL")
            
          ElseIf LTBUTTON_State Or (LBUTTON_State And TBUTTON_State And RBUTTON_State=0 And BBUTTON_State=0)
            widget::ResizeWidget(DBUTTON, size, size, size*2, size*2)
            widget::SetWidgetText(Button, "LEFT&TOP")
          ElseIf RTBUTTON_State Or (LBUTTON_State=0 And TBUTTON_State And RBUTTON_State And BBUTTON_State=0)
            widget::ResizeWidget(DBUTTON, width - size, size, size*2, size*2)
            widget::SetWidgetText(Button, "TOP&RIGHT")
          ElseIf RBBUTTON_State Or (LBUTTON_State=0 And TBUTTON_State=0 And RBUTTON_State And BBUTTON_State)
            widget::ResizeWidget(DBUTTON, width - size, height - size, size*2, size*2)
            widget::SetWidgetText(Button, "RIGHT&BOTTOM")
          ElseIf LBBUTTON_State Or (LBUTTON_State And TBUTTON_State=0 And RBUTTON_State=0 And BBUTTON_State)
            widget::ResizeWidget(DBUTTON, size, height - size, size*2, size*2)
            widget::SetWidgetText(Button, "BOTTOM&LEFT")
            
          ElseIf LBUTTON_State And TBUTTON_State And BBUTTON_State
            widget::ResizeWidget(DBUTTON, size, size, size*2, height)
            widget::SetWidgetText(Button, "FULLLEFT")
          ElseIf LBUTTON_State And TBUTTON_State And RBUTTON_State
            widget::ResizeWidget(DBUTTON, size, size, width, size*2)
            widget::SetWidgetText(Button, "FULLTOP")
          ElseIf TBUTTON_State And RBUTTON_State And BBUTTON_State
            widget::ResizeWidget(DBUTTON, width - size, size, size*2, height)
            widget::SetWidgetText(Button, "FULLRIGHT")
          ElseIf LBUTTON_State And RBUTTON_State And BBUTTON_State
            widget::ResizeWidget(DBUTTON, size, height - size, width, size*2)
            widget::SetWidgetText(Button, "FULLBOTTOM")
            
          ElseIf LBUTTON_State And RBUTTON_State
            widget::ResizeWidget(DBUTTON, size, y, width, size*2)
            widget::SetWidgetText(Button, "LEFT&RIGHT")
          ElseIf TBUTTON_State And BBUTTON_State
            widget::ResizeWidget(DBUTTON, x, size, size*2, height)
            widget::SetWidgetText(Button, "TOP&BOTTOM")
            
          ElseIf LBUTTON_State
            widget::ResizeWidget(DBUTTON, size, y, size*2, size*2)
            widget::SetWidgetText(Button, "LEFT")
          ElseIf TBUTTON_State
            widget::ResizeWidget(DBUTTON, x, size, size*2, size*2)
            widget::SetWidgetText(Button, "TOP")
          ElseIf RBUTTON_State
            widget::ResizeWidget(DBUTTON, width - size, y, size*2, size*2)
            widget::SetWidgetText(Button, "RIGHT")
          ElseIf BBUTTON_State
            widget::ResizeWidget(DBUTTON, x, height - size, size*2, size*2)
            widget::SetWidgetText(Button, "BOTTOM")
            
          Else
            If Not CENTER_State And *this = CENTER 
              widget::ResizeWidget(DBUTTON, size, size, width, height)
              widget::SetWidgetText(Button, "FULL")
              widget::SetWidgetState(LBUTTON, 1) ; left
              widget::SetWidgetState(TBUTTON, 1) ; top
              widget::SetWidgetState(RBUTTON, 1) ; right
              widget::SetWidgetState(BBUTTON, 1) ; bottom
            Else
              widget::ResizeWidget(DBUTTON, x, y, size*2, size*2)
              widget::SetWidgetText(Button, "CENTER")
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
     
    Button = widget::ButtonWidget(x,y,width, height, "LEFT&TOP",constants::#__flag_ButtonToggle);,-1,radius)
    
    Protected *a.Structures::_s_widget = widget::ContainerWidget(0,0,width,box_height)         ;, constants::#__flag_child)
   ;widget::SetWidgetFrame(a,fs)
    height1 - fs*2
    width1 - fs*2
    Protected x1 = size + width1
    Protected y1 = size + height1
    DBUTTON = widget::ButtonWidget(size, size, size*2, size*2, "",0,-1,radius)
    
    LBUTTON = widget::ButtonWidget(0, 0, size, size, "",constants::#__flag_ButtonToggle,-1,radius)
    LTBUTTON = widget::ButtonWidget(0, 0, size, size, "",constants::#__flag_ButtonToggle,-1,radius)
    TBUTTON = widget::ButtonWidget(0, 0, size, size, "",constants::#__flag_ButtonToggle,-1,radius)
    
    RTBUTTON = widget::ButtonWidget(0, 0, size, size, "",constants::#__flag_ButtonToggle,-1,radius)
    RBUTTON = widget::ButtonWidget(0, 0, size, size, "",constants::#__flag_ButtonToggle,-1,radius)
    RBBUTTON = widget::ButtonWidget(0, 0, size, size, "",constants::#__flag_ButtonToggle,-1,radius)
    
    BBUTTON = widget::ButtonWidget(0, 0, size, size, "",constants::#__flag_ButtonToggle,-1,radius)
    LBBUTTON = widget::ButtonWidget(0, 0, size, size, "",constants::#__flag_ButtonToggle,-1,radius)
    CENTER = widget::ButtonWidget(0, 0, size, size, "",constants::#__flag_ButtonToggle,-1,radius)
    
    
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
    
    widget::SetWidgetState( LBUTTON,1 )
    widget::SetWidgetState( LTBUTTON,1 )
    widget::SetWidgetState( TBUTTON,1 )
    widget::CloseWidgetList( )
    
    ;widget::SetWidgetColor(a, constants::#__color_back, widget::GetWidgetColor( widget::GetParent( a ), constants::#__color_back) )
    
    widget::BindWidgetEvent(LTBUTTON, @Events( ), constants::#__event_LeftClick )
    widget::BindWidgetEvent(LBUTTON, @Events( ), constants::#__event_LeftClick )
    widget::BindWidgetEvent(RTBUTTON, @Events( ), constants::#__event_LeftClick )
    widget::BindWidgetEvent(TBUTTON, @Events( ), constants::#__event_LeftClick )
    widget::BindWidgetEvent(CENTER, @Events( ), constants::#__event_LeftClick )
    widget::BindWidgetEvent(RBUTTON, @Events( ), constants::#__event_LeftClick )
    widget::BindWidgetEvent(RBBUTTON, @Events( ), constants::#__event_LeftClick )
    widget::BindWidgetEvent(BBUTTON, @Events( ), constants::#__event_LeftClick )
    widget::BindWidgetEvent(LBBUTTON, @Events( ), constants::#__event_LeftClick )
    
    widget::Hide(*a,1)
    widget::SetWidgetData(Button, *a)
    widget::BindWidgetEvent(BUTTON, @Events( ), constants::#__event_LeftClick )
    
    ProcedureReturn *a
  EndProcedure
EndModule


CompilerIf #PB_Compiler_IsMainFile
  If widget::OpenRoot( #PB_Any, 0, 0, 222+222, 205+70+100, "Buttons on the canvas", #PB_Window_SystemMenu | #PB_Window_ScreenCentered ) 
    
    AnchorBox::Create(30,30,250,30)
    
  EndIf
  
  widget::WaitClose( )
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 97
; FirstLine = 93
; Folding = ---
; EnableXP
; DPIAware