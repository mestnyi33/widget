 XIncludeFile "../../../widgets.pbi"
; fixed 778 commit
;-
 
 CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  Uselib(widget)
  
  Global object, parent
  Declare CustomEvents( )
  
  ;\\
  Open(0, 0, 0, 600, 600, "Demo bounds", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_SizeGadget)
  a_init(root(), 4)
  Define i,fs = 10
  ;\\
  ; parent = Window(50, 50, 500, 500, "parent", #PB_Window_SystemMenu)
  ; parent = Window(50, 50, 500, 500, "parent", #PB_Window_BorderLess)
  parent = Container(50, 50, 500, 500)
  widget()\fs = fs : Resize(widget(), #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
  SetColor(parent, #__color_back, $FFE9E9E9)
  
  ;\\
  object = Window(100, 100, 250, 220, "Resize me !", #PB_Window_SystemMenu | #PB_Window_SizeGadget, parent)
   ; object = Window(100, 100, 250, 220, "Resize me !", #PB_Window_BorderLess | #PB_Window_SizeGadget, parent)
  ;object = Container(100, 100, 250, 250) : CloseList()
  ;object = String(100, 100, 250, 250, "string", #__flag_borderless)
  ;object = Button(100, 100, 250, 250, "button");, #__flag_borderless)
  ;object = Tree(100, 100, 250, 250) : For i=0 To 10 : additem(object,-1,""+Str(i)) : Next
   
;   ;\\
   widget()\fs = 50 : Resize(widget(), #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
  
  ;\\
  Define anchor_size = 30
  a_set(parent, #__a_full, anchor_size/2)
  a_set(object, #__a_full, anchor_size)
  ;a_set(object, #__a_full, anchor_size, 0)
  ;a_set(object, #__a_full, anchor_size, anchor_size)
  
;   a_set(object, #__a_full, anchor_size*2)
;   a_set(object, #__a_full, anchor_size*2, 5)
;   a_set(object, #__a_full, anchor_size)
  
  ;\\
  SizeBounds(object, anchor_size*2, anchor_size*2, 460, 460)
  ;MoveBounds(object, fs, fs, 501-fs, 501-fs)
  MoveBounds(object, 0, 0, 501-fs*2, 501-fs*2)
  
  ;\\
  Bind( parent, @CustomEvents(), #__event_statuschange )
  Bind( parent, @CustomEvents(), #__event_resize )
  
  ;\\
  Bind( object, @CustomEvents(), #__event_statuschange )
  Bind( object, @CustomEvents(), #__event_resize )
  WaitClose( )
  
  ;\\
  Procedure CustomEvents( )
    Select WidgetEventType( )
          
       Case #__event_statuschange
          If EventWidget( )\show
             Debug "statuschange "
          EndIf
          
       Case #__event_resize
          Debug "resize "+EventWidget( )\class +" "+ EventWidget( )\frame_width( ) +" "+ EventWidget( )\frame_height( )
          
    EndSelect
 EndProcedure
 
CompilerEndIf

CompilerIf #PB_Compiler_IsMainFile = 99
  EnableExplicit
  Uselib(widget)
  
  Global object, parent
  Declare CustomEvents( )
  
  ;\\
  Open(0, 0, 0, 600, 600, "Demo bounds", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_SizeGadget)
  a_init(root(), 4)
  Define fs = 20
  ;\\
  ; parent = Window(50, 50, 500, 500, "parent", #PB_Window_SystemMenu)
  ; parent = Window(50, 50, 500, 500, "parent", #PB_Window_BorderLess)
  parent = Container(50, 50, 500, 500)
  widget()\fs = fs : Resize(widget(), #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
  
  ;\\
  ; object = Window(100, 100, 250, 220, "Resize me !", #PB_Window_SystemMenu | #PB_Window_SizeGadget, parent)
  object = Window(100, 100, 250, 220, "Resize me !", #PB_Window_BorderLess | #PB_Window_SizeGadget, parent)
  ; object = Container(100, 100, 250, 250) : CloseList()
  ; object = ScrollArea(100, 100, 250, 250, 350,350, 1) : CloseList()
  ; object = ScrollArea(100, 100, 250, 250, 150,150, 1) : CloseList()
  
  ;\\
  widget()\fs = fs : Resize(widget(), #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
  
  ;\\
  a_set(parent, #__a_full, 18)
  a_set(object, #__a_full, 18)
  
  ;\\
; ;   SizeBounds(object, 200, 200, 501-fs*2, 501-fs*2)
; ;   MoveBounds(object, fs, fs, 501-fs, 501-fs)
  
  ;\\
  Bind( widget( ), @CustomEvents(), #__event_draw )
  WaitClose( )
  
  ;\\
  Procedure CustomEvents( )
    Select WidgetEventType( )
      Case #__event_draw
        
        ; Demo draw on element
        UnclipOutput()
        DrawingMode(#PB_2DDrawing_Outlined)
        
        If Eventwidget()\bounds\move
          Box(Eventwidget()\parent\x[#__c_frame] + Eventwidget()\bounds\move\min\x,
              Eventwidget()\parent\y[#__c_frame] + Eventwidget()\parent\fs[2] + Eventwidget()\bounds\move\min\y,
              Eventwidget()\bounds\move\max\x-Eventwidget()\bounds\move\min\x,
              Eventwidget()\bounds\move\max\y-Eventwidget()\bounds\move\min\y, $ff0000ff)
        EndIf
        
        If Eventwidget()\bounds\size
;           Box(Eventwidget()\bounds\size\min\width,
;               Eventwidget()\bounds\size\min\height,
;               Eventwidget()\bounds\size\max\width-Eventwidget()\bounds\size\min\width,
;               Eventwidget()\bounds\size\max\height-Eventwidget()\bounds\size\min\height, $ffff0000)
          
          Box(Eventwidget()\x[#__c_frame],
              Eventwidget()\y[#__c_frame],
              Eventwidget()\bounds\size\min\width,
              Eventwidget()\bounds\size\min\height, $ff00ff00)
          
          Box(Eventwidget()\x[#__c_frame],
              Eventwidget()\y[#__c_frame],
              Eventwidget()\bounds\size\max\width,
              Eventwidget()\bounds\size\max\height, $ffff0000)
        EndIf
        
        ; Box(Eventwidget()\x,Eventwidget()\y,Eventwidget()\width,Eventwidget()\height, draw_color)
        
    EndSelect
    
  EndProcedure
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (Windows - x64)
; Folding = v-
; EnableXP