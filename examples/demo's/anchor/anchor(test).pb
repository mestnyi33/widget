 XIncludeFile "../../../widgets.pbi"
; fixed 778 commit
;-
 
 CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseWidgets( )
  
  Global object, parent
  Declare CustomEvents( )
  
  ;\\
  OpenRootWidget(0, 0, 0, 600, 600, "Demo bounds", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_SizeGadget)
  a_init(root(), 4)
  Define i,fs = 10
  ;\\
  ; parent = WindowWidget(50, 50, 500, 500, "parent", #PB_Window_SystemMenu)
  ; parent = WindowWidget(50, 50, 500, 500, "parent", #PB_Window_BorderLess)
  parent = ContainerWidget(50, 50, 500, 500)
  widget()\fs = fs : ResizeWidget(widget(), #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
  SetWidgetColor(parent, #__color_back, $FFE9E9E9)
  
  ;\\
  object = WindowWidget(100, 100, 250, 220, "Resize me !", #PB_Window_SystemMenu | #PB_Window_SizeGadget, parent)
   ; object = WindowWidget(100, 100, 250, 220, "Resize me !", #PB_Window_BorderLess | #PB_Window_SizeGadget, parent)
  ;object = ContainerWidget(100, 100, 250, 250) : CloseWidgetList()
  ;object = StringWidget(100, 100, 250, 250, "string", #__flag_borderless)
  ;object = ButtonWidget(100, 100, 250, 250, "button");, #__flag_borderless)
  ;object = TreeWidget(100, 100, 250, 250) : For i=0 To 10 : additem(object,-1,""+Str(i)) : Next
   
;   ;\\
   widget()\fs = 50 : ResizeWidget(widget(), #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
  
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
  SetSizeBounds(object, anchor_size*2, anchor_size*2, 460, 460)
  ;MoveBounds(object, fs, fs, 501-fs, 501-fs)
  SetMoveBounds(object, 0, 0, 501-fs*2, 501-fs*2)
  
  ;\\
  BindWidgetEvent( parent, @CustomEvents(), #__event_statuschange )
  BindWidgetEvent( parent, @CustomEvents(), #__event_resize )
  
  ;\\
  BindWidgetEvent( object, @CustomEvents(), #__event_statuschange )
  BindWidgetEvent( object, @CustomEvents(), #__event_resize )
  WaitCloseRootWidget( )
  
  ;\\
  Procedure CustomEvents( )
    Select WidgetEvent( )
          
       Case #__event_statuschange
          If EventWidget( )\hide = 0 ; show
             Debug "statuschange "
          EndIf
          
       Case #__event_resize
          Debug "resize "+EventWidget( )\class +" "+ EventWidget( )\frame_width( ) +" "+ EventWidget( )\frame_height( )
          
    EndSelect
 EndProcedure
 
CompilerEndIf

CompilerIf #PB_Compiler_IsMainFile = 99
  EnableExplicit
  UseWidgets( )
  
  Global object, parent
  Declare CustomEvents( )
  
  ;\\
  OpenRootWidget(0, 0, 0, 600, 600, "Demo bounds", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_SizeGadget)
  a_init(root(), 4)
  Define fs = 20
  ;\\
  ; parent = WindowWidget(50, 50, 500, 500, "parent", #PB_Window_SystemMenu)
  ; parent = WindowWidget(50, 50, 500, 500, "parent", #PB_Window_BorderLess)
  parent = ContainerWidget(50, 50, 500, 500)
  widget()\fs = fs : ResizeWidget(widget(), #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
  
  ;\\
  ; object = WindowWidget(100, 100, 250, 220, "Resize me !", #PB_Window_SystemMenu | #PB_Window_SizeGadget, parent)
  object = WindowWidget(100, 100, 250, 220, "Resize me !", #PB_Window_BorderLess | #PB_Window_SizeGadget, parent)
  ; object = ContainerWidget(100, 100, 250, 250) : CloseWidgetList()
  ; object = ScrollAreaWidget(100, 100, 250, 250, 350,350, 1) : CloseWidgetList()
  ; object = ScrollAreaWidget(100, 100, 250, 250, 150,150, 1) : CloseWidgetList()
  
  ;\\
  widget()\fs = fs : ResizeWidget(widget(), #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
  
  ;\\
  a_set(parent, #__a_full, 18)
  a_set(object, #__a_full, 18)
  
  ;\\
; ;   SetSizeBounds(object, 200, 200, 501-fs*2, 501-fs*2)
; ;   SetMoveBounds(object, fs, fs, 501-fs, 501-fs)
  
  ;\\
  BindWidgetEvent( widget( ), @CustomEvents(), #__event_draw )
  WaitCloseRootWidget( )
  
  ;\\
  Procedure CustomEvents( )
    Select WidgetEvent( )
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
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 63
; FirstLine = 59
; Folding = --
; EnableXP