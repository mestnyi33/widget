IncludePath "../../os/mac/"
XIncludeFile "id.pbi"
XIncludeFile "mouse.pbi"
XIncludeFile "cursor.pbi"
XIncludeFile "parent.pbi"


Global *dragged=-1, *entered=-1, *focused=-1, *pressed=-1, *setcallback

Macro DraggedGadget() : *dragged : EndMacro
Macro EnteredGadget() : *entered : EndMacro
Macro FocusedGadget() : *focused : EndMacro
Macro PressedGadget() : *pressed : EndMacro




DraggedGadget() =- 1 
EnteredGadget() =- 1 
PressedGadget() =- 1 
FocusedGadget() =- 1 

ProcedureC  eventTapFunction(proxy, eType, event, refcon)
  Protected Point.CGPoint
  Protected *cursor.cursor::_s_cursor = #Null
  Protected NSEvent = CocoaMessage(0, 0, "NSEvent eventWithCGEvent:", event)
  ;Protected NSEnter = CocoaMessage(0, 0, "NSEvent eventWithCGEvent:", event)
  
  If refcon And NSEvent
    Static LeftClick, ClickTime, MouseDrag, MouseMoveX, MouseMoveY, DeltaX, DeltaY, LeftDoubleClickTime
    Protected MouseMove, MouseX, MouseY, MoveStart, LeftDoubleClick, EnteredID, gadget =- 1
    
    ;       If eType = #NSMouseEntered
    ;         Debug "en "+proxy+" "+CocoaMessage(0, CocoaMessage(0, NSEvent, "window"), "contentView") +" "+CocoaMessage(0, NSEvent, "windowNumber")
    ;       EndIf
    ;       If eType = #NSMouseExited
    ;         Debug "le "+proxy+" "+ CocoaMessage(0, NSEvent, "windowNumber")
    ;       EndIf
    If eType = #NSLeftMouseDown
      ;Debug CocoaMessage(0, Mouse::Gadget(Mouse::Window()), "pressedMouseButtons")
      MouseDrag = 1
    ElseIf eType = #NSLeftMouseUp
      MouseDrag = 0
      ;         If EnteredGadget() >= 0 
      ;           If DraggedGadget() >= 0 And DraggedGadget() = PressedGadget() 
      ;             CompilerIf Defined(constants::PB_EventType_Drop, #PB_Constant) 
      ;               CallCFunctionFast(refcon, EnteredGadget(), constants::#PB_EventType_Drop)
      ;             CompilerEndIf
      ;           EndIf
      ;           
      ;           If Not (LeftDoubleClickTime And ElapsedMilliseconds() - LeftDoubleClickTime < DoubleClickTime())
      ;             LeftDoubleClickTime = ElapsedMilliseconds() 
      ;           Else
      ;             LeftDoubleClick = 1
      ;           EndIf
      ;         EndIf
    EndIf
    
    If MouseDrag >= 0 
      EnteredID = Mouse::Gadget(Mouse::Window())
    EndIf
    
    ;
    If EnteredID
      gadget = ID::Gadget(EnteredID)
      
      If gadget >= 0
        Mousex = GadgetMouseX(gadget)
        Mousey = GadgetMouseY(gadget)
      Else
        Mousex =- 1
        Mousey =- 1
      EndIf
    Else
      Mousex =- 1
      Mousey =- 1
    EndIf
    
    ;
    If MouseDrag And
       Mousex =- 1 And Mousey =- 1
      
      If PressedGadget() >= 0
        Mousex = GadgetMouseX(PressedGadget())
        Mousey = GadgetMouseY(PressedGadget())
      EndIf
    EndIf
    
    If MouseMoveX <> Mousex
      MouseMoveX = Mousex
      MouseMove = #True
    EndIf
    
    If MouseMoveY <> Mousey
      MouseMoveY = Mousey
      MouseMove = #True
    EndIf
    
    ;
    If MouseMove 
      If MouseDrag >= 0 And 
         EnteredGadget() <> gadget
        If EnteredGadget() >= 0 ;And GadgetType(EnteredGadget()) = #PB_GadgetType_Canvas
          If Not MouseDrag
            Cursor::change(EnteredGadget(), 0)
          EndIf
          
          CallCFunctionFast(refcon, EnteredGadget() , #PB_EventType_MouseLeave)
        EndIf
        
        EnteredGadget() = gadget
        
        If EnteredGadget() >= 0 ;And GadgetType(EnteredGadget()) = #PB_GadgetType_Canvas
          If Not MouseDrag
            Cursor::change(EnteredGadget(),1)
          EndIf
          
          CallCFunctionFast(refcon, EnteredGadget(), #PB_EventType_MouseEnter)
        EndIf
      Else
        ; mouse drag start
        If MouseDrag > 0
          If EnteredGadget() >= 0 And
             DraggedGadget() <> PressedGadget()
            DraggedGadget() = PressedGadget()
            CallCFunctionFast(refcon, PressedGadget(), #PB_EventType_DragStart)
            DeltaX = GadgetX(PressedGadget()) 
            DeltaY = GadgetY(PressedGadget())
          EndIf
        EndIf
        
        If MouseDrag And EnteredGadget() <> PressedGadget()
          CallCFunctionFast(refcon, PressedGadget(), #PB_EventType_MouseMove)
        EndIf
        
        If EnteredGadget() >= 0
          CallCFunctionFast(refcon, EnteredGadget(), #PB_EventType_MouseMove)
          
          ; if move gadget x&y position
          If MouseDrag > 0 And PressedGadget() = EnteredGadget() 
            If DeltaX <> GadgetX(PressedGadget()) Or 
               DeltaY <> GadgetY(PressedGadget())
              MouseDrag =- 1
            EndIf
          EndIf
        EndIf
      EndIf
    EndIf
    
    ;
    If eType = #NSLeftMouseDown
      PressedGadget() = EnteredGadget() ; EventGadget()
                                        ;Debug CocoaMessage(0, Mouse::Window(), "focusView")
      
      If PressedGadget() >= 0
        If FocusedGadget() =- 1
          FocusedGadget() = PressedGadget() ; GetActiveGadget()
          If GadgetType(FocusedGadget()) = #PB_GadgetType_Canvas
            CallCFunctionFast(refcon, FocusedGadget(), #PB_EventType_Focus)
          EndIf
        EndIf
        
        If FocusedGadget() >= 0 And 
           FocusedGadget() <> PressedGadget()
          CallCFunctionFast(refcon, FocusedGadget(), #PB_EventType_LostFocus)
          
          FocusedGadget() = PressedGadget()
          CallCFunctionFast(refcon, FocusedGadget(), #PB_EventType_Focus)
        EndIf
        
        CallCFunctionFast(refcon, PressedGadget(), #PB_EventType_LeftButtonDown)
      EndIf
    EndIf
    
    ;
    If eType = #NSLeftMouseUp
      If PressedGadget() >= 0 And 
         PressedGadget() <> gadget  
        Cursor::change(PressedGadget(), 0)
      EndIf
      
      If gadget >= 0 And 
         gadget <> PressedGadget()
        EnteredGadget() = gadget
        Cursor::change(EnteredGadget(),1)
      EndIf
      
      If PressedGadget() >= 0 
        CallCFunctionFast(refcon, PressedGadget(), #PB_EventType_LeftButtonUp)
        
        If LeftDoubleClick
          CallCFunctionFast(refcon, PressedGadget(), #PB_EventType_LeftDoubleClick)
        Else
          If PressedGadget() <> DraggedGadget()
            If PressedGadget() >= 0 And EnteredID = GadgetID(PressedGadget())
              CallCFunctionFast(refcon, PressedGadget(), #PB_EventType_LeftClick)
            EndIf
          EndIf
        EndIf
      EndIf
      
      ; PressedGadget() =- 1
      DraggedGadget() =- 1
    EndIf
    
    ;         ;
    ;         If eType = #PB_EventType_LeftDoubleClick
    ;           CallCFunctionFast(refcon, EnteredGadget(), #PB_EventType_LeftDoubleClick)
    ;         EndIf
    
    ; ;       If eType = #NSScrollWheel
    ; ;         ;NSEvent = CocoaMessage(0, 0, "NSEvent eventWithCGEvent:", event)
    ; ;         
    ; ;         If NSEvent
    ; ;           Protected scrollX = CocoaMessage(0, NSEvent, "scrollingDeltaX")
    ; ;           Protected scrollY = CocoaMessage(0, NSEvent, "scrollingDeltaY")
    ; ;           
    ; ;           If scrollX And Not scrollY
    ; ;             ; Debug "X - scroll"
    ; ;             If EnteredGadget() >= 0
    ; ;               CompilerIf Defined(constants::PB_EventType_MouseWheelY, #PB_Constant) 
    ; ;                 CallCFunctionFast(refcon, EnteredGadget(), constants::#PB_EventType_MouseWheelX, scrollX)
    ; ;               CompilerEndIf
    ; ;             EndIf
    ; ;           EndIf
    ; ;           
    ; ;           If scrollY And Not scrollX
    ; ;             ; Debug "Y - scroll"
    ; ;             If EnteredGadget() >= 0
    ; ;               CompilerIf Defined(constants::PB_EventType_MouseWheelX, #PB_Constant) 
    ; ;                 CallCFunctionFast(refcon, EnteredGadget(), constants::#PB_EventType_MouseWheelY, scrollY)
    ; ;               CompilerEndIf
    ; ;             EndIf
    ; ;           EndIf
    ; ;         EndIf
    ; ;       EndIf
    
    
    ;           If eType = #PB_EventType_Resize
    ;             ; CallCFunctionFast(refcon, EventGadget(), #PB_EventType_Resize)
    ;           EndIf
    ;           CompilerIf Defined(PB_EventType_Repaint, #PB_Constant) And Defined(constants, #PB_Module)
    ;             If eType = #PB_EventType_Repaint
    ;               CallCFunctionFast(refcon, EventGadget(), #PB_EventType_Repaint)
    ;             EndIf
    ;           CompilerEndIf
    ;           
  EndIf
  
EndProcedure
ImportC ""
  CFRunLoopGetCurrent()
  CFRunLoopAddCommonMode(rl, mode)
  
  GetCurrentProcess(*psn)
  CGEventTapCreateForPSN(*psn, place.i, options.i, eventsOfInterest.q, callback.i, refcon)
  CGEventTapCreate(tap.i, place.i, options.i, eventsOfInterest.q, callback.i, refcon)
EndImport
Procedure   SetCallBack(*callback)
  *setcallback = *callback
  
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



CompilerIf #PB_Compiler_IsMainFile ;= 100
  EnableExplicit
  UsePNGImageDecoder()
  
  If Not LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/Background.bmp")
    End
  EndIf
  
  If Not LoadImage(1, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png")
    End
  EndIf
  
  Global x,y,i
  
  Procedure scrolled()
    
  EndProcedure
  
  Procedure EventHandler(eventobject, eventtype, eventdata)
    Protected window = EventWindow()
    Static parentID, parent =-1, first=-1, second=-1
    
    If eventobject <> 315
      Select eventtype
        Case #PB_EventType_MouseEnter
          Debug ""+eventobject + " #PB_EventType_MouseEnter "
          ;           parentID = Parent::get(GadgetID(eventobject))
          ;           
          ;           If Not ID::IsWindowID(parentID)
          ;             parent = ID::Gadget(parentID)
          ;           Else
          ;             parent=-1
          ;           EndIf
          ;           
          ;           If IsGadget(parent) And GadgetType(parent) = #PB_GadgetType_Splitter
          ;             first = GetGadgetAttribute(parent, #PB_Splitter_FirstGadget)
          ;             Second = GetGadgetAttribute(parent, #PB_Splitter_SecondGadget)
          ;             
          ;             If first = eventobject
          ;               SetGadgetAttribute(parent, #PB_Splitter_FirstGadget, 315)
          ;             ElseIf Second = eventobject
          ;               SetGadgetAttribute(parent, #PB_Splitter_SecondGadget, 315)
          ;             EndIf
          ;             Parent::set(eventobject, GadgetID(315))
          ;           Else
          ;             Parent::set(315, parentID)
          ;             ResizeGadget(315, GadgetX(eventobject)-1, GadgetY(eventobject)-1, GadgetWidth(eventobject)+2, GadgetHeight(eventobject)+2)
          ;             ResizeGadget(eventobject, 1, 1, #PB_Ignore, #PB_Ignore)
          ;             Parent::set(eventobject, GadgetID(315))
          ;           EndIf
          ;           
          ;           Cursor::setCursor(GadgetID(eventobject), #PB_Cursor_Hand)
          PostEvent(#PB_Event_Gadget, EventWindow(), eventobject, eventtype, eventdata)
          
        Case #PB_EventType_MouseLeave
          Debug ""+eventobject + " #PB_EventType_MouseLeave "
          ;             If first = eventobject
          ;               SetGadgetAttribute(parent, #PB_Splitter_FirstGadget, first)
          ;               first =- 1
          ;             ElseIf Second = eventobject
          ;               SetGadgetAttribute(parent, #PB_Splitter_SecondGadget, Second)
          ;               Second =- 1
          ;             Else
          ;               ResizeGadget(eventobject, GadgetX(315)+1, GadgetY(315)+1, #PB_Ignore, #PB_Ignore)
          ;               Parent::set(eventobject, parentID)
          ; ;              ResizeGadget(Parent, 0,0,0,0)
          ;             EndIf
          PostEvent(#PB_Event_Gadget, EventWindow(), eventobject, eventtype, eventdata)
      EndSelect
    EndIf
  EndProcedure
  
  SetCallBack(@EventHandler())
  
  If OpenWindow(#PB_Any, 0, 0, 995, 605, "", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    Define WindowID = UseGadgetList(0)
    ButtonGadget(#PB_GadgetType_Button, 5, 5, 160,95, "Multiline Button_"+Str(#PB_GadgetType_Button)+" (longer text gets automatically multiline)", #PB_Button_MultiLine ) 
    StringGadget(#PB_GadgetType_String, 5, 105, 160,95, "String_"+Str(#PB_GadgetType_String)+" set"+#LF$+"multi"+#LF$+"line"+#LF$+"text")                                 
    TextGadget(#PB_GadgetType_Text, 5, 205, 160,95, "Text_"+Str(#PB_GadgetType_Text)+#LF$+"set"+#LF$+"multi"+#LF$+"line"+#LF$+"text", #PB_Text_Border)        
    CheckBoxGadget(#PB_GadgetType_CheckBox, 5, 305, 160,95, "CheckBox_"+Str(#PB_GadgetType_CheckBox), #PB_CheckBox_ThreeState) : SetGadgetState(#PB_GadgetType_CheckBox, #PB_Checkbox_Inbetween)
    OptionGadget(#PB_GadgetType_Option, 5, 405, 160,95, "Option_"+Str(#PB_GadgetType_Option) ) : SetGadgetState(#PB_GadgetType_Option, 1)                                                       
    ListViewGadget(#PB_GadgetType_ListView, 5, 505, 160,95) : AddGadgetItem(#PB_GadgetType_ListView, -1, "ListView_"+Str(#PB_GadgetType_ListView)) : For i=1 To 5 : AddGadgetItem(#PB_GadgetType_ListView, i, "item_"+Str(i)) : Next
    FrameGadget(#PB_GadgetType_Frame, 170, 5, 160,95, "Frame_"+Str(#PB_GadgetType_Frame) )
    ComboBoxGadget(#PB_GadgetType_ComboBox, 170, 105, 160,95) : AddGadgetItem(#PB_GadgetType_ComboBox, -1, "ComboBox_"+Str(#PB_GadgetType_ComboBox)) : For i=1 To 5 : AddGadgetItem(#PB_GadgetType_ComboBox, i, "item_"+Str(i)) : Next : SetGadgetState(#PB_GadgetType_ComboBox, 0) 
    ImageGadget(#PB_GadgetType_Image, 170, 205, 160,95, 0, #PB_Image_Border ) 
    HyperLinkGadget(#PB_GadgetType_HyperLink, 170, 305, 160,95,"HyperLink_"+Str(#PB_GadgetType_HyperLink), $00FF00, #PB_HyperLink_Underline ) 
    ContainerGadget(#PB_GadgetType_Container, 170, 405, 160,95, #PB_Container_Flat )
    OptionGadget(101, 10, 10, 110,20, "Container_"+Str(#PB_GadgetType_Container) )  : SetGadgetState(101, 1)  
    OptionGadget(102, 10, 40, 110,20, "Option_widget");, #pb_flag_flat)  
    CloseGadgetList()
    ListIconGadget(#PB_GadgetType_ListIcon,170, 505, 160,95,"ListIcon_"+Str(#PB_GadgetType_ListIcon),120 )                           
    
    IPAddressGadget(#PB_GadgetType_IPAddress, 335, 5, 160,95 ) : SetGadgetState(#PB_GadgetType_IPAddress, MakeIPAddress(1, 2, 3, 4))    
    ProgressBarGadget(#PB_GadgetType_ProgressBar, 335, 105, 160,95,0,100) : SetGadgetState(#PB_GadgetType_ProgressBar, 50)
    ScrollBarGadget(#PB_GadgetType_ScrollBar, 335, 205, 160,95,0,100,0) : SetGadgetState(#PB_GadgetType_ScrollBar, 40)
    ScrollAreaGadget(#PB_GadgetType_ScrollArea, 335, 305, 160,95,180,90,1, #PB_ScrollArea_Flat ) :  ButtonGadget(201, 0, 0, 150,20, "ScrollArea_"+Str(#PB_GadgetType_ScrollArea) ) :  ButtonGadget(202, 180-150, 90-20, 150,20, "Button_"+Str(202) ) : CloseGadgetList()
    TrackBarGadget(#PB_GadgetType_TrackBar, 335, 405, 160,95,0,21, #PB_TrackBar_Ticks) : SetGadgetState(#PB_GadgetType_TrackBar, 11)
    WebGadget(#PB_GadgetType_Web, 335, 505, 160,95,"https://www.purebasic.com" )
    
    ButtonImageGadget(#PB_GadgetType_ButtonImage, 500, 5, 160,95, ImageID(0), 1)
    CalendarGadget(#PB_GadgetType_Calendar, 500, 105, 160,95 )
    DateGadget(#PB_GadgetType_Date, 500, 205, 160,95 )
    EditorGadget(#PB_GadgetType_Editor, 500, 305, 160,95 ) : AddGadgetItem(#PB_GadgetType_Editor, -1, "set"+#LF$+"editor"+#LF$+"_"+Str(#PB_GadgetType_Editor) +#LF$+"add"+#LF$+"multi"+#LF$+"line"+#LF$+"text")  
    ExplorerListGadget(#PB_GadgetType_ExplorerList, 500, 405, 160,95,"" )
    ExplorerTreeGadget(#PB_GadgetType_ExplorerTree, 500, 505, 160,95,"" )
    
    ExplorerComboGadget(#PB_GadgetType_ExplorerCombo, 665, 5, 160,95,"" )
    SpinGadget(#PB_GadgetType_Spin, 665, 105, 160,95,20,100)
    
    TreeGadget(#PB_GadgetType_Tree, 665, 205, 160, 95 ) 
    AddGadgetItem(#PB_GadgetType_Tree, -1, "Tree_"+Str(#PB_GadgetType_Tree)) 
    For i=1 To 5 : AddGadgetItem(#PB_GadgetType_Tree, i, "item_"+Str(i)) : Next
    ButtonGadget(-1,665+10,205+5,50,35, "444444") 
    
    PanelGadget(#PB_GadgetType_Panel,665, 305, 160,95) 
    AddGadgetItem(#PB_GadgetType_Panel, -1, "Panel_"+Str(#PB_GadgetType_Panel)) 
    ButtonGadget(255, 0, 0, 90,20, "Button_255" ) 
    For i=1 To 5 : AddGadgetItem(#PB_GadgetType_Panel, i, "item_"+Str(i)) : ButtonGadget(-1,10,5,50,35, "butt_"+Str(i)) : Next 
    CloseGadgetList()
    
    OpenGadgetList(#PB_GadgetType_Panel, 1)
    ContainerGadget(-1,10,5,150,55, #PB_Container_Flat) 
    ContainerGadget(-1,10,5,150,55, #PB_Container_Flat) 
    ButtonGadget(-1,10,5,50,35, "butt_1") 
    CloseGadgetList()
    CloseGadgetList()
    CloseGadgetList()
    SetGadgetState( #PB_GadgetType_Panel, 4)
    
    SpinGadget(301, 0, 0, 100,20,0,10)
    SpinGadget(302, 0, 0, 100,20,0,10)                 
    SplitterGadget(#PB_GadgetType_Splitter, 665, 405, 160, 95, 301, 302)
    
    InitScintilla()
    ScintillaGadget(#PB_GadgetType_Scintilla, 830, 5, 160,95,0 )
    ShortcutGadget(#PB_GadgetType_Shortcut, 830, 105, 160,95 ,-1)
    CanvasGadget(#PB_GadgetType_Canvas, 830, 205, 160,95 )
    CanvasGadget(#PB_GadgetType_Canvas+1, 830, 305, 160,95, #PB_Canvas_Container )
    CloseGadgetList()
    
    ContainerGadget(315,0,0,0,0);, #PB_Container_Flat) 
    SetGadgetColor(315, #PB_Gadget_BackColor, RGB(255, 0, 0))
    CloseGadgetList()
    
    Define enGadget=-1,leGadget=-1,parent =-1, first=-1, second=-1
    Define handle,parentID, eventobject=-1
    
    ;; Cursor::setCursor(GadgetID(1), #PB_Cursor_Hand)
    
    Repeat
      Define  Event = WaitWindowEvent()
      ;       handle = Mouse::Gadget( Mouse::Window( ) )
      ;       If handle
      ;         enGadget = ID::Gadget( handle )
      ;         
      ;         If leGadget <> enGadget
      ;           If leGadget >= 0 And leGadget <> 315 
      ;             If first = leGadget
      ;               SetGadgetAttribute(parent, #PB_Splitter_FirstGadget, first)
      ;               first =- 1
      ;             ElseIf Second = leGadget
      ;               SetGadgetAttribute(parent, #PB_Splitter_SecondGadget, Second)
      ;               Second =- 1
      ;             Else
      ;               ResizeGadget(leGadget, GadgetX(315)+1, GadgetY(315)+1, #PB_Ignore, #PB_Ignore)
      ;               Parent::set(leGadget, parentID)
      ;             EndIf
      ;           EndIf
      ;           
      ;           leGadget = enGadget
      ;           
      ;           If enGadget >= 0  And enGadget <> 315 
      ;           parentID = Parent::get(GadgetID(enGadget))
      ;           If Not ID::IsWindowID(parentID)
      ;             parent = ID::Gadget(parentID)
      ;           Else
      ;             parent=-1
      ;           EndIf
      ;           
      ;           If IsGadget(parent) And GadgetType(parent) = #PB_GadgetType_Splitter
      ;             first = GetGadgetAttribute(parent, #PB_Splitter_FirstGadget)
      ;             Second = GetGadgetAttribute(parent, #PB_Splitter_SecondGadget)
      ;             
      ;             If first = leGadget
      ;               SetGadgetAttribute(parent, #PB_Splitter_FirstGadget, 315)
      ;             ElseIf Second = leGadget
      ;               SetGadgetAttribute(parent, #PB_Splitter_SecondGadget, 315)
      ;             EndIf
      ;             Parent::set(leGadget, GadgetID(315))
      ;           Else
      ;             Parent::set(315, parentID)
      ;             ResizeGadget(315, GadgetX(leGadget)-1, GadgetY(leGadget)-1, GadgetWidth(leGadget)+2, GadgetHeight(leGadget)+2)
      ;             ResizeGadget(leGadget, 1, 1, #PB_Ignore, #PB_Ignore)
      ;             Parent::set(leGadget, GadgetID(315))
      ;           EndIf
      ;           
      ;           Cursor::setCursor(GadgetID(leGadget), #PB_Cursor_Hand)
      ;         EndIf
      ;         ;Debug ""+ leGadget
      ;         EndIf
      ;       EndIf
      ;       
      
      Select event 
        Case #PB_Event_Gadget
          eventobject = EventGadget()
          If eventobject <> 315
            If EventType() = #PB_EventType_MouseEnter
              parentID = Parent::get(GadgetID(eventobject))
              
              If Not ID::IsWindowID(parentID)
                parent = ID::Gadget(parentID)
              Else
                parent=-1
              EndIf
              
              If IsGadget(parent) And GadgetType(parent) = #PB_GadgetType_Splitter
                first = GetGadgetAttribute(parent, #PB_Splitter_FirstGadget)
                Second = GetGadgetAttribute(parent, #PB_Splitter_SecondGadget)
                
                If first = eventobject
                  SetGadgetAttribute(parent, #PB_Splitter_FirstGadget, 315)
                ElseIf Second = eventobject
                  SetGadgetAttribute(parent, #PB_Splitter_SecondGadget, 315)
                EndIf
                Parent::set(eventobject, GadgetID(315))
              Else
                Parent::set(315, parentID)
                ResizeGadget(315, GadgetX(eventobject)-1, GadgetY(eventobject)-1, GadgetWidth(eventobject)+2, GadgetHeight(eventobject)+2)
                ResizeGadget(eventobject, 1, 1, #PB_Ignore, #PB_Ignore)
                Parent::set(eventobject, GadgetID(315))
              EndIf
              
              Cursor::set(eventobject, #PB_Cursor_Cross)
            EndIf
            If EventType() = #PB_EventType_MouseLeave
              If first = eventobject
                SetGadgetAttribute(parent, #PB_Splitter_FirstGadget, first)
                first =- 1
              ElseIf Second = eventobject
                SetGadgetAttribute(parent, #PB_Splitter_SecondGadget, Second)
                Second =- 1
              Else
                ResizeGadget(eventobject, GadgetX(315)+1, GadgetY(315)+1, #PB_Ignore, #PB_Ignore)
                Parent::set(eventobject, parentID)
                ;              ResizeGadget(Parent, 0,0,0,0)
              EndIf
            EndIf
          EndIf
      EndSelect
    Until Event= #PB_Event_CloseWindow
    
  EndIf   
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 14
; FirstLine = 3
; Folding = ----------
; EnableXP