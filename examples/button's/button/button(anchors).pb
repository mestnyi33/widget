﻿IncludePath "../../../"
XIncludeFile "widgets.pbi"

DeclareModule AnchorBox
  EnableExplicit
  
  Declare Create(x,y,width,height)
EndDeclareModule

Module AnchorBox
  Global Button_2,
         Button_1,
         Button_4,
         Button_3,
         Button_9,
         Button_5,
         Button_8,
         Button_7,
         Button_6,
         Button_0,
         Button_10
  
  Global size = 16
  Global radius = 7
  
  Procedure Events( )
    
    Select widget::WidgetEventType( )
      Case #PB_EventType_LeftClick 
        Protected *this = widget::EventWidget( )
        
        If *this = Button_10 
          Protected a = widget::GetData(*this)
          widget::Hide(a, Bool( Not widget::GetState(*this)))
          widget::Resize(a, widget::X(*this), widget::Y(*this)+widget::Height(*this), #PB_Ignore, #PB_Ignore )
         ; widget::Display(a, *this)
        Else
          ;\\
          If *this <> Button_9 ; center 
            widget::SetState(Button_9, 0) 
          EndIf
          
          If *this <> Button_1 And 
             *this <> Button_3 And 
             *this <> Button_5 And 
             *this <> Button_7
            
            widget::SetState(Button_1, 0); left  
            widget::SetState(Button_3, 0); top  
            widget::SetState(Button_5, 0); right  
            widget::SetState(Button_7, 0); bottom  
          EndIf
          
          If *this = Button_2 ; left & top 
            widget::SetState(Button_1, 1) ; left
            widget::SetState(Button_3, 1) ; top
          Else
            widget::SetState(Button_2, 0) 
          EndIf
          
          If *this = Button_4 ; right & top 
            widget::SetState(Button_3, 1) ; top
            widget::SetState(Button_5, 1) ; right
          Else
            widget::SetState(Button_4, 0) 
          EndIf
          
          If *this = Button_8 ; left & bottom 
            widget::SetState(Button_1, 1) ; left
            widget::SetState(Button_7, 1) ; bottom
          Else
            widget::SetState(Button_8, 0) 
          EndIf
          
          If *this = Button_6 ; right & bottom 
            widget::SetState(Button_5, 1) ; right
            widget::SetState(Button_7, 1) ; bottom
          Else
            widget::SetState(Button_6, 0) 
          EndIf
          
          ;\\
          Protected Button_2_State = widget::GetState(Button_2)
          Protected Button_1_State = widget::GetState(Button_1)
          Protected Button_4_State = widget::GetState(Button_4)
          Protected Button_3_State = widget::GetState(Button_3)
          Protected Button_9_State = widget::GetState(Button_9)
          Protected Button_5_State = widget::GetState(Button_5)
          Protected Button_8_State = widget::GetState(Button_8)
          Protected Button_7_State = widget::GetState(Button_7)
          Protected Button_6_State = widget::GetState(Button_6)
          
          ;\\
          Protected x = widget::X( Button_9, constants::#__c_container ) - size / 2
          Protected width  = widget::X( Button_5, constants::#__c_container ) - size
          
          Protected y = widget::Y( Button_9, constants::#__c_container ) - size / 2
          Protected height = widget::Y( Button_7, constants::#__c_container ) - size
          
          ;\\
          If Button_1_State And Button_3_State And Button_5_State And Button_7_State
            widget::Resize(Button_0, size, size, width, height)
            widget::SetText(Button_10, "FULL")
            
          ElseIf Button_2_State Or (Button_1_State And Button_3_State And Button_5_State=0 And Button_7_State=0)
            widget::Resize(Button_0, size, size, size*2, size*2)
            widget::SetText(Button_10, "LEFT&TOP")
          ElseIf Button_4_State Or (Button_1_State=0 And Button_3_State And Button_5_State And Button_7_State=0)
            widget::Resize(Button_0, width - size, size, size*2, size*2)
            widget::SetText(Button_10, "TOP&RIGHT")
          ElseIf Button_6_State Or (Button_1_State=0 And Button_3_State=0 And Button_5_State And Button_7_State)
            widget::Resize(Button_0, width - size, height - size, size*2, size*2)
            widget::SetText(Button_10, "RIGHT&BOTTOM")
          ElseIf Button_8_State Or (Button_1_State And Button_3_State=0 And Button_5_State=0 And Button_7_State)
            widget::Resize(Button_0, size, height - size, size*2, size*2)
            widget::SetText(Button_10, "BOTTOM&LEFT")
            
          ElseIf Button_1_State And Button_3_State And Button_7_State
            widget::Resize(Button_0, size, size, size*2, height)
            widget::SetText(Button_10, "FULLLEFT")
          ElseIf Button_1_State And Button_3_State And Button_5_State
            widget::Resize(Button_0, size, size, width, size*2)
            widget::SetText(Button_10, "FULLTOP")
          ElseIf Button_3_State And Button_5_State And Button_7_State
            widget::Resize(Button_0, width - size, size, size*2, height)
            widget::SetText(Button_10, "FULLRIGHT")
          ElseIf Button_1_State And Button_5_State And Button_7_State
            widget::Resize(Button_0, size, height - size, width, size*2)
            widget::SetText(Button_10, "FULLBOTTOM")
            
          ElseIf Button_1_State And Button_5_State
            widget::Resize(Button_0, size, y, width, size*2)
            widget::SetText(Button_10, "LEFT&RIGHT")
          ElseIf Button_3_State And Button_7_State
            widget::Resize(Button_0, x, size, size*2, height)
            widget::SetText(Button_10, "TOP&BOTTOM")
            
          ElseIf Button_1_State
            widget::Resize(Button_0, size, y, size*2, size*2)
            widget::SetText(Button_10, "LEFT")
          ElseIf Button_3_State
            widget::Resize(Button_0, x, size, size*2, size*2)
            widget::SetText(Button_10, "TOP")
          ElseIf Button_5_State
            widget::Resize(Button_0, width - size, y, size*2, size*2)
            widget::SetText(Button_10, "RIGHT")
          ElseIf Button_7_State
            widget::Resize(Button_0, x, height - size, size*2, size*2)
            widget::SetText(Button_10, "BOTTOM")
            
          Else
            If Not Button_9_State And *this = Button_9 
              widget::Resize(Button_0, size, size, width, height)
              widget::SetText(Button_10, "FULL")
              widget::SetState(Button_1, 1) ; left
              widget::SetState(Button_3, 1) ; top
              widget::SetState(Button_5, 1) ; right
              widget::SetState(Button_7, 1) ; bottom
            Else
              widget::Resize(Button_0, x, y, size*2, size*2)
              widget::SetText(Button_10, "CENTER")
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
    
    Button_10 = widget::Button(x,y,width, height, "LEFT&TOP",constants::#__button_toggle);,-1,radius)
    Protected *a.Structures::_s_widget = widget::Container(0,0,width,box_height);, constants::#__flag_child)
    Protected fs = 1
    ;widget::SetFrame(a,fs)
    height1 - fs*2
    width1 - fs*2
    Protected x1 = size + width1
    Protected y1 = size + height1
    Button_0 = widget::Button(size, size, size*2, size*2, "",0,-1,radius)
    
    Button_1 = widget::Button(0, size, size, height1, "",constants::#__button_toggle,-1,radius)
    Button_2 = widget::Button(0, 0, size, size, "",constants::#__button_toggle,-1,radius)
    Button_3 = widget::Button(size, 0, width1, size, "",constants::#__button_toggle,-1,radius)
    
    Button_4 = widget::Button(x1, 0, size, size, "",constants::#__button_toggle,-1,radius)
    Button_5 = widget::Button(x1, size, size, height1, "",constants::#__button_toggle,-1,radius)
    Button_6 = widget::Button(x1, y1, size, size, "",constants::#__button_toggle,-1,radius)
    
    Button_7 = widget::Button(size, y1, width1, size, "",constants::#__button_toggle,-1,radius)
    Button_8 = widget::Button(0, y1, size, size, "",constants::#__button_toggle,-1,radius)
    Button_9 = widget::Button((width1+size)/2, (height1+size)/2, size, size, "",constants::#__button_toggle,-1,radius)
    
    widget::SetState( Button_1,1 )
    widget::SetState( Button_2,1 )
    widget::SetState( Button_3,1 )
    widget::CloseList( )
    
    ;widget::setColor(a, constants::#__color_back, widget::GetColor( widget::GetParent( a ), constants::#__color_back) )
    
    widget::Bind(Button_2, @Events( ), #PB_EventType_LeftClick )
    widget::Bind(Button_1, @Events( ), #PB_EventType_LeftClick )
    widget::Bind(Button_4, @Events( ), #PB_EventType_LeftClick )
    widget::Bind(Button_3, @Events( ), #PB_EventType_LeftClick )
    widget::Bind(Button_9, @Events( ), #PB_EventType_LeftClick )
    widget::Bind(Button_5, @Events( ), #PB_EventType_LeftClick )
    widget::Bind(Button_6, @Events( ), #PB_EventType_LeftClick )
    widget::Bind(Button_7, @Events( ), #PB_EventType_LeftClick )
    widget::Bind(Button_8, @Events( ), #PB_EventType_LeftClick )
    
    widget::Hide(*a,1)
    widget::SetData(Button_10, *a)
    widget::Bind(Button_10, @Events( ), #PB_EventType_LeftClick )
    
    ProcedureReturn *a
  EndProcedure
EndModule


CompilerIf #PB_Compiler_IsMainFile
  If widget::Open( #PB_Any, 0, 0, 222+222, 205+70+100, "Buttons on the canvas", #PB_Window_SystemMenu | #PB_Window_ScreenCentered ) 
    
    AnchorBox::Create(30,30,250,30)
    
  EndIf
  
  widget::WaitClose( )
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = ---
; EnableXP