﻿ XIncludeFile "../../../widgets.pbi"
; fixed 778 commit
;-
 
 CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseWidgets( )
  
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
  SetColor(parent, #pb_gadget_backcolor, $FFE9E9E9)
  
  ;\\
  object = Window(100, 100, 250, 220, "Resize me !", #PB_Window_SystemMenu | #PB_Window_SizeGadget, parent)
   ; object = Window(100, 100, 250, 220, "Resize me !", #PB_Window_BorderLess | #PB_Window_SizeGadget, parent)
  ;object = Container(100, 100, 250, 250) : CloseList()
  ;object = String(100, 100, 250, 250, "string", #__flag_border_less)
  ;object = Button(100, 100, 250, 250, "button");, #__flag_border_less)
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
  SetSizeBounds(object, anchor_size*2, anchor_size*2, 460, 460)
  ;MoveBounds(object, fs, fs, 501-fs, 501-fs)
  SetMoveBounds(object, 0, 0, 501-fs*2, 501-fs*2)
  
  ;\\
  Bind( parent, @CustomEvents(), #__event_statuschange )
  Bind( parent, @CustomEvents(), #__event_resize )
  
  ;\\
  Bind( object, @CustomEvents(), #__event_statuschange )
  Bind( object, @CustomEvents(), #__event_resize )
  WaitClose( )
  
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
  Open(0, 0, 0, 600, 600, "Demo bounds", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_SizeGadget)
  a_init(root(), 4)
  
  ;\\
  ; parent = Window(50, 50, 500, 500, "parent", #PB_Window_SystemMenu)
  ; parent = Window(50, 50, 500, 500, "parent", #PB_Window_BorderLess)
  parent = Container(50, 50, 500, 500)
  
  ;\\
  ; object = Window(100, 100, 250, 220, "Resize me !", #PB_Window_SystemMenu | #PB_Window_SizeGadget, parent)
  object = Window(100, 100, 250, 220, "Resize me !", #PB_Window_BorderLess | #PB_Window_SizeGadget, parent)
  ; object = Container(100, 100, 250, 250) : CloseList()
  ; object = ScrollArea(100, 100, 250, 250, 350,350, 1) : CloseList()
  ; object = ScrollArea(100, 100, 250, 250, 150,150, 1) : CloseList()
  
  ;\\
   Define fs = 20
   SetFrame( parent, fs )
   SetFrame( object, fs )
   
   
  ;\\
  a_set(parent, #__a_full, 18)
  a_set(object, #__a_full, 18)
  
  
  ;\\
  Bind( widget( ), @CustomEvents(), #__event_draw )
  WaitClose( )
  
  ;\\
  Procedure CustomEvents( )
    Select WidgetEvent( )
      Case #__event_draw
        
        ; Demo draw on element
        UnclipOutput()
        DrawingMode(#PB_2DDrawing_Outlined)
        
        If EventWidget()\bounds\move
          Box(EventWidget()\parent\x[#__c_frame] + EventWidget()\bounds\move\min\x,
              EventWidget()\parent\y[#__c_frame] + EventWidget()\parent\fs[2] + EventWidget()\bounds\move\min\y,
              EventWidget()\bounds\move\max\x-EventWidget()\bounds\move\min\x,
              EventWidget()\bounds\move\max\y-EventWidget()\bounds\move\min\y, $ff0000ff)
        EndIf
        
        If EventWidget()\bounds\size
;           Box(Eventwidget()\bounds\size\min\width,
;               Eventwidget()\bounds\size\min\height,
;               Eventwidget()\bounds\size\max\width-Eventwidget()\bounds\size\min\width,
;               Eventwidget()\bounds\size\max\height-Eventwidget()\bounds\size\min\height, $ffff0000)
          
          Box(EventWidget()\x[#__c_frame],
              EventWidget()\y[#__c_frame],
              EventWidget()\bounds\size\min\width,
              EventWidget()\bounds\size\min\height, $ff00ff00)
          
          Box(EventWidget()\x[#__c_frame],
              EventWidget()\y[#__c_frame],
              EventWidget()\bounds\size\max\width,
              EventWidget()\bounds\size\max\height, $ffff0000)
        EndIf
        
        ; Box(Eventwidget()\x,Eventwidget()\y,Eventwidget()\width,Eventwidget()\height, draw_color)
        
    EndSelect
    
  EndProcedure
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 20
; FirstLine = 16
; Folding = --
; EnableXP
; DPIAware