IncludePath "../../../"
XIncludeFile "widget-events.pbi"

CompilerIf #PB_Compiler_IsMainFile
  ; Shows possible flags of ButtonGadget in action...
  EnableExplicit
  UseLib( Widget )
  Global Button_0,
         Button_1,
         Button_2,
         Button_3,
         Button_4,
         Button_5,
         Button_6,
         Button_7,
         Button_8,
         Button_9,
         Button_10
  
  Global size = 16
  Global radius = 7
     
  Procedure Anchors_events( )
    
    Select WidgetEventType( )
      Case #PB_EventType_LeftClick
        Protected width = Width(Button_9)
        Protected height = Height(Button_9)
        Protected state = GetState(EventWidget( ))
;         state ! 1
;         ;state = Bool(state=0)
;         Debug state 
;         ;SetState(EventWidget( ), state )
        
        
        Select EventWidget( )
          Case Button_0
            Resize(Button_9, size, size, #PB_Ignore, #PB_Ignore)
          Case Button_2
            Resize(Button_9, X( Button_2, #__c_container )-width, size, #PB_Ignore, #PB_Ignore)
          Case Button_4
            Resize(Button_9, X( Button_4, #__c_container )-size/2, Y( Button_4, #__c_container )-size/2, #PB_Ignore, #PB_Ignore)
          Case Button_6
            Resize(Button_9, size, Y( Button_6, #__c_container )-height, #PB_Ignore, #PB_Ignore)
          Case Button_8
            Resize(Button_9, X( Button_8, #__c_container )-width, Y( Button_8, #__c_container )-height, #PB_Ignore, #PB_Ignore)
            
          Case Button_3
            Resize(Button_9, size, Y( Button_4, #__c_container )-size/2, #PB_Ignore, #PB_Ignore)
          Case Button_5
            Resize(Button_9, X( Button_5, #__c_container )-width, Y( Button_4, #__c_container )-size/2, #PB_Ignore, #PB_Ignore)
            
          Case Button_1
            Resize(Button_9, X( Button_4, #__c_container )-size/2, size, #PB_Ignore, #PB_Ignore)
          Case Button_7
            Resize(Button_9, X( Button_4, #__c_container )-size/2, Y( Button_7, #__c_container )-height, #PB_Ignore, #PB_Ignore)
            
        EndSelect  
    EndSelect
    
  EndProcedure
  
  Procedure Anchors(x,y,width,height)
    Protected width1 = width-size*2; -2
    Protected height1 = height-size*2; -2
    Protected x1 = size + width1
    Protected y1 = size + height1
    
    Protected a = Container(x,y,width,height, #__flag_borderless)
    Button_9 = Button(size, size, size*2, size*2, "",0,-1,radius)
    
    Button_0 = Button(0, 0, size, size, "",#__button_toggle,-1,radius)
    Button_1 = Button(size, 0, width1, size, "",#__button_toggle,-1,radius)
    Button_2 = Button(x1, 0, size, size, "",#__button_toggle,-1,radius)
    
    Button_3 = Button(0, size, size, height1, "",#__button_toggle,-1,radius)
    Button_4 = Button((width-size)/2, (height-size)/2, size, size, "",#__button_toggle,-1,radius)
    Button_5 = Button(x1, size, size, height1, "",#__button_toggle,-1,radius)
    
    Button_6 = Button(0, y1, size, size, "",#__button_toggle,-1,radius)
    Button_7 = Button(size, y1, width1, size, "",#__button_toggle,-1,radius)
    Button_8 = Button(x1, y1, size, size, "",#__button_toggle,-1,radius)
    
    SetState( Button_0,1 )
    SetState( Button_1,1 )
    SetState( Button_3,1 )
    CloseList( )
    
    setColor(a, #__color_back, GetColor( GetParent( a ), #__color_back) )
    
    Bind(Button_0, @Anchors_events( ), #PB_EventType_LeftClick )
    Bind(Button_1, @Anchors_events( ), #PB_EventType_LeftClick )
    Bind(Button_2, @Anchors_events( ), #PB_EventType_LeftClick )
    Bind(Button_3, @Anchors_events( ), #PB_EventType_LeftClick )
    Bind(Button_4, @Anchors_events( ), #PB_EventType_LeftClick )
    Bind(Button_5, @Anchors_events( ), #PB_EventType_LeftClick )
    Bind(Button_6, @Anchors_events( ), #PB_EventType_LeftClick )
    Bind(Button_7, @Anchors_events( ), #PB_EventType_LeftClick )
    Bind(Button_8, @Anchors_events( ), #PB_EventType_LeftClick )
;     Bind(Button_9, @Anchors_events( ), #PB_EventType_LeftClick )
;     Bind(Button_10, @Anchors_events( ), #PB_EventType_LeftClick )
    ProcedureReturn a
  EndProcedure
  
  If Open( #PB_Any, 0, 0, 222+222, 205+70, "Buttons on the canvas", #PB_Window_SystemMenu | #PB_Window_ScreenCentered ) 
    
    Anchors(30,30,150,100 )
    
  EndIf
  
  WaitClose( )
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = --
; EnableXP