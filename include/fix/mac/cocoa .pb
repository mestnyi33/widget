;https://www.purebasic.fr/english/viewtopic.php?t=59589
EnableExplicit

Procedure InitRect(*rect.NSRect,x,y,width,height)
    If *rect
        *rect\origin\x = x
        *rect\origin\y = y
        *rect\size\width = width
        *rect\size\height = height
    EndIf
EndProcedure

Procedure InitSize(*size.NSSize,width,height)
    If *size
        *size\width = width
        *size\height = height
    EndIf
EndProcedure

Procedure PushButton(x,y,width,height,title.s)
    Protected btn, rect.NSRect
    CocoaMessage(@btn,0,"NSButton alloc")
    If btn
        ;CocoaMessage(0,btn,"init")
        InitRect(@rect,x,y,width,height)
        CocoaMessage(@btn,btn,"initWithFrame:@",@rect)
        CocoaMessage(0,btn,"setTitle:$",@title)
        CocoaMessage(0,btn,"setButtonType:",0)
        CocoaMessage(0,btn,"setBezelStyle:",1)
    EndIf
    ProcedureReturn btn
EndProcedure

Procedure StickyButton(x,y,width,height,title.s)
    Protected btn, rect.NSRect
    CocoaMessage(@btn,0,"NSButton alloc")
    If btn
        ;CocoaMessage(0,btn,"init")
        InitRect(@rect,x,y,width,height)
        CocoaMessage(@btn,btn,"initWithFrame:@",@rect)
        CocoaMessage(0,btn,"setTitle:$",@title)
        CocoaMessage(0,btn,"setButtonType:",1)
        CocoaMessage(0,btn,"setBezelStyle:",1)
    EndIf
    ProcedureReturn btn
EndProcedure

Procedure Checkbox(x,y,width,height,title.s)
    Protected btn, rect.NSRect
    CocoaMessage(@btn,0,"NSButton alloc")
    If btn
        ;CocoaMessage(0,btn,"init")
        InitRect(@rect,x,y,width,height)
        CocoaMessage(@btn,btn,"initWithFrame:@",@rect)
        CocoaMessage(0,btn,"setTitle:$",@title)
        CocoaMessage(0,btn,"setButtonType:",3)
        CocoaMessage(0,btn,"setBezelStyle:",1)
    EndIf
    ProcedureReturn btn
EndProcedure

Procedure RadioButton(x,y,width,height,title.s)
    Protected btn, rect.NSRect
    CocoaMessage(@btn,0,"NSButton alloc")
    If btn
        ;CocoaMessage(0,btn,"init")
        InitRect(@rect,x,y,width,height)
        CocoaMessage(@btn,btn,"initWithFrame:@",@rect)
        CocoaMessage(0,btn,"setTitle:$",@title)
        CocoaMessage(0,btn,"setButtonType:",4)
        CocoaMessage(0,btn,"setBezelStyle:",1)
    EndIf
    ProcedureReturn btn
EndProcedure

Procedure Frame(x,y,width,height,title.s)
    Protected box, rect.NSRect
    CocoaMessage(@box,0,"NSBox alloc")
    If box
        InitRect(@rect,x,y,width,height)
        CocoaMessage(@box,box,"initWithFrame:@",@rect)
        CocoaMessage(0,box,"setTitle:$",@title)
    EndIf
    ProcedureReturn box
EndProcedure

Procedure RadioButtonGroup(x,y,width,height,names.s)
    Protected matrix, rect.NSRect, size.NSSize, index, cell, name.s
    
    CocoaMessage(@matrix,0,"NSMatrix alloc")
    If matrix
        InitRect(@rect,x,y,width,height)
        CocoaMessage(@matrix,matrix,"initWithFrame:@",@rect)
        CocoaMessage(@cell,0,"NSButtonCell alloc")
        CocoaMessage(0,cell,"init")
        CocoaMessage(0,cell,"setButtonType:",4)
        CocoaMessage(0,cell,"setBezelStyle:",1)
        CocoaMessage(0,cell,"setTitle:$",@"----------------------------------")
        CocoaMessage(@matrix,matrix,"initWithFrame:@",@rect,"mode:",0,"prototype:",cell,"numberOfRows:",0,"numberOfColumns:",0)
        CocoaMessage(0,matrix,"setAutoscroll:",#YES)
        CocoaMessage(0,matrix,"setAutorecalculatesCellSize:",#YES)
        ;CocoaMessage(0,cell,"release")

        index = 1
        Repeat
            name = StringField(names,index,"|")
            If name
                CocoaMessage(0,matrix,"addRow")
                CocoaMessage(@cell,matrix,"cellAtRow:",index-1,"column:",0)
                If cell
                    CocoaMessage(0,cell,"setTitle:$",@name)
                EndIf
            EndIf
            index + 1
        Until name = ""
        CocoaMessage(0,matrix,"setAutorecalculatesCellSize:",#YES)
    EndIf
    ProcedureReturn matrix
EndProcedure

Procedure CheckboxGroup(x,y,width,height,names.s)
    Protected matrix, rect.NSRect, size.NSSize, index, cell, name.s
    Protected space$ = Space(500)
    CocoaMessage(@matrix,0,"NSMatrix alloc")
    If matrix
        InitRect(@rect,x,y,width,height)
        CocoaMessage(@matrix,matrix,"initWithFrame:@",@rect)
        CocoaMessage(@cell,0,"NSButtonCell alloc")
        CocoaMessage(0,cell,"init")
        CocoaMessage(0,cell,"setButtonType:",3)
        CocoaMessage(0,cell,"setBezelStyle:",1)
        CocoaMessage(0,cell,"setTitle:$",@space$)
        CocoaMessage(@matrix,matrix,"initWithFrame:@",@rect,"mode:",0,"prototype:",cell,"numberOfRows:",0,"numberOfColumns:",0)
        CocoaMessage(0,matrix,"setAutoscroll:",#YES)
        CocoaMessage(0,matrix,"setAutorecalculatesCellSize:",#YES)
        ;CocoaMessage(0,cell,"release")
        index = 1
        Repeat
            name = StringField(names,index,"|")
            If name
                CocoaMessage(0,matrix,"addRow")
                CocoaMessage(@cell,matrix,"cellAtRow:",index-1,"column:",0)
                If cell
                   CocoaMessage(0,cell,"setTitle:$",@name)
                EndIf
            EndIf
            index + 1
        Until name = ""
        CocoaMessage(0,matrix,"setAutorecalculatesCellSize:",#YES)
    EndIf
    ProcedureReturn matrix
EndProcedure



Procedure App()
    Protected app
    CocoaMessage(@app,0,"NSApplication sharedApplication")
    ProcedureReturn app
EndProcedure

Procedure Window(x,y,width,height,title.s,mask,center=0)
    Protected size.NSSize, rect.NSRect, win, view
    CocoaMessage(@win,0,"NSWindow alloc")
    If win
        InitRect(@rect,x,y,width,height)
        CocoaMessage(0,win,"initWithContentRect:@",@rect,"styleMask:",mask,"backing:",2,"defer:",#NO)
        CocoaMessage(0,win,"makeKeyWindow")
        CocoaMessage(0,Win,"makeKeyAndOrderFront:",App())
        CocoaMessage(0,win,"setTitle:$",@title)
        ;InitSize(@size,width,height)
        ;CocoaMessage(0,win,"setMinSize:",size)
        
        ;CocoaMessage(0,win,"setPreventsApplicationTerminationWhenModal:",#NO)
        ;CocoaMessage(0,win,"setReleasedWhenClosed:",#YES)
        
        CocoaMessage(@view,0,"NSView alloc")
        If view
            InitRect(@rect,0,0,width,height)
            CocoaMessage(@view,view,"initWithFrame:@",@rect)
            CocoaMessage(0,win,"setContentView:",view)
        EndIf
        
        If center
            CocoaMessage(0,win,"center")
        EndIf
        CocoaMessage(0,win,"update")
        CocoaMessage(0,win,"display")
    EndIf
    ProcedureReturn win
EndProcedure

Procedure AddGadgetToWindow(win,gadget)
    Protected view
    If win And gadget
        CocoaMessage(@view,win,"contentView")
        If view
            CocoaMessage(0,view,"addSubview:",gadget)
        EndIf
    EndIf
EndProcedure

Procedure AddGadgetToFrame(frame,gadget)
    If frame And gadget
        CocoaMessage(0,frame,"addSubview:",gadget)
    EndIf
EndProcedure

Procedure AddGadgetToMatrix(matrix,gadget,row,column)
    If matrix And gadget
        CocoaMessage(0,matrix,"putCell:",gadget,"atRow:",row,"column:",column)
    EndIf
EndProcedure

;--------------------------------------------------------------------

#NSBorderlessWindowMask = 0
#NSTitledWindowMask = 1 << 0
#NSClosableWindowMask = 1 << 1
#NSMiniaturizableWindowMask = 1 << 2
#NSResizableWindowMask = 1 << 3
#NSTexturedBackgroundWindowMask = 1 << 8


#MASK = #NSTitledWindowMask | #NSClosableWindowMask | #NSMiniaturizableWindowMask |
        #NSResizableWindowMask ;| #NSTexturedBackgroundWindowMask

Define win, frame

win = Window(100,100,800,600,"My Window",#MASK,1)
If win
    AddGadgetToWindow(win,PushButton(10,10,150,25,"Push Button"))
    AddGadgetToWindow(win,StickyButton(10,45,150,25,"Sticky Button"))
    AddGadgetToWindow(win,Checkbox(10,80,150,25,"Checkbox"))
    AddGadgetToWindow(win,RadioButton(10,115,150,25,"Radio Button"))
    frame = Frame(10,150,450,200,"Frame")
    If frame
        AddGadgetToFrame(frame,PushButton(10,10,120,25,"Button 1"))
        AddGadgetToFrame(frame,PushButton(10,45,120,25,"Button 2"))
        AddGadgetToFrame(frame,RadioButtonGroup(140,10,120,160,"RadioBtn 1|RadioBtn 2|RadioBtn 3|RadioBtn 4|RadioBtn 5"))
        AddGadgetToFrame(frame,CheckboxGroup(270,10,120,160,"CheckBox 1|CheckBox 2|CheckBox 3|CheckBox 4|CheckBox 5"))
        AddGadgetToWindow(win,frame)
    EndIf
EndIf


Procedure EventClose( )
  Debug 77777
  
EndProcedure
BindEvent(#PB_Event_CloseWindow, @EventClose( ) )

ProcedureC  eventTapFunction(proxy, eType, event, refcon)
  Debug 44444
EndProcedure

 ImportC ""
    CFRunLoopGetCurrent()
    CFRunLoopAddCommonMode(rl, mode)
    
    GetCurrentProcess(*psn)
    CGEventTapCreateForPSN(*psn, place.i, options.i, eventsOfInterest.q, callback.i, refcon)
    CGEventTapCreate(tap.i, place.i, options.i, eventsOfInterest.q, callback.i, refcon)
  EndImport
  
  Procedure   SetCallBack(*callback)
    ;*setcallback = *callback
    
    Protected mask, EventTap
    mask = #NSMouseMovedMask | #NSScrollWheelMask
    mask | #NSMouseEnteredMask | #NSMouseExitedMask 
    mask | #NSLeftMouseDownMask | #NSLeftMouseUpMask 
    mask | #NSRightMouseDownMask | #NSRightMouseDownMask 
    mask | #NSLeftMouseDraggedMask | #NSRightMouseDraggedMask   ;| #NSCursorUpdateMask
    
    #cghidEventTap = 0              ; Указывает, что отвод события размещается в точке, где системные события HID поступают на оконный сервер.
    #cgSessionEventTap = 1          ; Указывает, что отвод события размещается в точке, где события системы HID и удаленного управления входят в сеанс входа в систему.
    #cgAnnotatedSessionEventTap = 2 ; Указывает, что отвод события размещается в точке, где события сеанса были аннотированы для передачи в приложение.
    
    #headInsertEventTap = 0         ; Указывает, что новое касание события должно быть вставлено перед любым ранее существовавшим касанием события в том же месте.
    #tailAppendEventTap = 1         ; Указывает, что новое касание события должно быть вставлено после любого ранее существовавшего касания события в том же месте
    
    
    ; GetCurrentProcess(@psn.q): eventTap = CGEventTapCreateForPSN(@psn, #headInsertEventTap, 1, mask, @eventTapFunction(), *callback)
    eventTap = CGEventTapCreate(2, 0, 1, mask, @eventTapFunction(), *callback)
    
    If eventTap
      CocoaMessage(0, CocoaMessage(0, 0, "NSRunLoop currentRunLoop"), "addPort:", eventTap, "forMode:$", @"kCFRunLoopDefaultMode")
    EndIf
    
  EndProcedure
  
SetCallBack(@EventClose( ))
CocoaMessage(0,App(),"run")
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = -------
; EnableXP