XIncludeFile "../../../widgets.pbi"
; fixed 778 commit
;-
; Bounds window example
CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
   Global object, parent
   Declare CustomEvents( )
   
   ;\\
   Open(0, 0, 0, 600, 600, "Demo bounds", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_SizeGadget)
   a_init(Root(), 4)
   
   ;\\
   ; parent = Window(50, 50, 500, 500, "parent", #PB_Window_SystemMenu)
   ; parent = Window(50, 50, 500, 500, "parent", #PB_Window_BorderLess)
   parent = Container(50, 50, 500, 500)
   
   ;\\
   ; object = Window(0, 0, 250, 220, "Resize me !", #PB_Window_SystemMenu | #PB_Window_SizeGadget, parent)
   ; object = Window(0, 0, 250, 220, "Resize me !", #PB_Window_BorderLess | #PB_Window_SizeGadget, parent)
   ; object = Container(0, 0, 250, 250) : CloseList()
object = ScrollArea(0, 0, 250, 250, 350,350, 1) : CloseList()
;  object = ScrollArea(0, 0, 250, 250, 150,150, 1) : CloseList()

;\\
Define fs = 20
SetFrame( parent, fs )
SetFrame( object, fs )

;\\
a_set(object, #__a_full, 8)
SetSizeBounds(object, 200, 200, 501-fs*2-fs*2, 501-fs*2-fs*2)
SetMoveBounds(object, fs, fs, 501-fs*2-fs, 501-fs*2-fs)

;\\
Bind( Widget( ), @CustomEvents(), #__event_Draw )
WaitClose( )

;\\
Procedure CustomEvents( )
   Select WidgetEvent( )
      Case #__event_Draw
         
         ; Demo draw on element
         UnclipOutput()
         DrawingMode(#PB_2DDrawing_Outlined)
         
         If EventWidget()\bounds\move
            Box(EventWidget()\parent\x[#__c_inner] + EventWidget()\bounds\move\min\x,
                EventWidget()\parent\y[#__c_inner] + EventWidget()\bounds\move\min\y,
                EventWidget()\bounds\move\max\x-EventWidget()\bounds\move\min\x,
                EventWidget()\bounds\move\max\y-EventWidget()\bounds\move\min\y, $ff0000ff)
         EndIf
         ;         If Eventwidget()\bounds\move
         ;           Box(Eventwidget()\parent\x[#__c_frame] + Eventwidget()\bounds\move\min\x,
         ;               Eventwidget()\parent\y[#__c_frame] + Eventwidget()\parent\fs[2] + Eventwidget()\bounds\move\min\y,
         ;               Eventwidget()\bounds\move\max\x-Eventwidget()\bounds\move\min\x,
         ;               Eventwidget()\bounds\move\max\y-Eventwidget()\bounds\move\min\y, $ff0000ff)
         ;         EndIf
         
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
; IDE Options = PureBasic 6.00 LTS (MacOS X - x64)
; CursorPosition = 24
; FirstLine = 7
; Folding = -
; EnableXP