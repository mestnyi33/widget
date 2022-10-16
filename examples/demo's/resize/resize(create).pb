

; ;XIncludeFile "../../../widgets.pbi" 
 XIncludeFile "../../../widget-events.pbi" 

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  Uselib( WIDGET )
  
  Procedure Events()
    Static DraggedGadget
    
    Protected eventobject = EventWidget( )
    
    Select WidgetEventType( )
      Case #PB_EventType_DragStart
        DraggedGadget = eventobject
        
      Case #PB_EventType_LeftButtonUp
        DraggedGadget = 0
        
      Case #PB_EventType_ResizeBegin
        Debug ""+GetClass(eventobject) + " #PB_EventType_ResizeBegin " 
        
      Case #PB_EventType_Resize
        Debug ""+GetClass(eventobject) + " #PB_EventType_Resize " 
        
      Case #PB_EventType_ResizeEnd
        Debug ""+GetClass(eventobject) + " #PB_EventType_ResizeEnd " 
        
      Case #PB_EventType_MouseMove
        If DraggedGadget 
          ;Debug Root()\canvas\resizebeginwidget ;GetClass(DraggedGadget)
           Resize(DraggedGadget, Mouse()\x-Mouse()\delta\x, Mouse()\y-Mouse()\delta\y, #PB_Ignore, #PB_Ignore)
          ;Debug Root()\canvas\resizebeginwidget
        EndIf
        
    EndSelect
  EndProcedure
  
  Procedure CreateWidget( *type )
    Protected result, x=50, y=50, width = 400, height = 300, flags ;= #__flag_autosize
    
    Select *type
      Case  1: result = Button(x,y,width,height,"Button", flags) 
      Case  2: result = String(x,y,width,height,"String", flags) 
      Case  3: result = Text(x,y,width,height,"Text", #PB_Text_Border|flags) 
      Case  4: result = Option(x,y,width,height,"Option", flags) 
      Case  5: result = CheckBox(x,y,width,height,"CheckBox", flags) 
      Case  6: result = ListView(x,y,width,height, flags) 
      Case  7: result = Frame(x,y,width,height,"Frame", flags) 
      Case  8: result = ComboBox(x,y,width,height, flags): AddItem(result,-1,"ComboBox"): SetState(result,0)
      Case  9: result = Image(x,y,width,height,0,#PB_Image_Border|flags) 
      Case 10: result = HyperLink(x,y,width,height,"HyperLink",0, flags) 
      Case 11: result = Container(x,y,width,height,#PB_Container_Flat|flags): Button(0,0,80,y,"Button"): CloseList() ; Container
      Case 12: result = ListIcon(x,y,width,height,"",88, flags) 
        ;Case 13: result = IPAddress(x,y,width,height) 
        ;Case 14: result = ProgressBar(x,y,width,height,0,5)
        ;Case 15: result = ScrollBar(x,y,width,height,5,335,9)
      Case 16: result = ScrollArea(x,y,width,height,width*2,height*2,9,#PB_ScrollArea_Flat|flags): Button(0,0,80,30,"Button"): CloseList()
        ;Case 17: result = TrackBar(x,y,width,height,0,5)
        ;Case 18: result = Web(x,y,width,height,"") ; bug 531 linux
      Case 19: result = ButtonImage(x,y,width,height,0, flags)
        ;Case 20: result = Calendar(x,y,width,height) 
        ;Case 21: result = Date(x,y,width,height)
      Case 22: result = Editor(x,y,width,height, flags):  AddItem(result,-1,"Editor")
        ;Case 23: result = ExplorerList(x,y,width,height,"")
        ;Case 24: result = ExplorerTree(x,y,width,height,"")
        ;Case 25: result = ExplorerCombo(x,y,width,height,"")
      Case 26: result = Spin(x,y,width,height,0,5,#PB_Spin_Numeric|flags)
      Case 27: result = Tree(x,y,width,height, flags) :  AddItem(result,-1,"Tree"):  AddItem(result,-1,"SubLavel",0,1)
      Case 28: result = Panel(x,y,width,height, flags): AddItem(result,-1,"Panel"): CloseList()
      Case 29 
        result = Splitter(x,y,width,height,Button(0,0,0,0,"1"),Button(0,0,0,0,"2"), flags)
        
      Case height: result = MDI(x,y,width,height, flags)
        ; Case 31: result = Scintilla(x,y,width,height,0, flags)
        ; Case 32: result = Shortcut(x,y,width,height,0, flags)
        ; Case 33: result = Canvas(x,y,width,height, flags) 
    EndSelect
    
    ProcedureReturn result
  EndProcedure
  
  If Open(OpenWindow(#PB_Any, 0, 0, 500, 400, "Example 1: Creation of a basic objects.", #PB_Window_SystemMenu | #PB_Window_ScreenCentered))
    SetColor(root(), #__color_back, RGBA(244, 245, 233, 255))
    ;a_init( root())
    
    Define widget = CreateWidget( #PB_GadgetType_Container )
    ;     ; CreateWidget( #PB_GadgetType_Editor )
    ;     Resize(Root(), 50,50,50,50)
    ;     Resize(Root(), 60,50,50,50)
    ;     Resize(Root(), 70,50,50,50)
    ;     Resize(Root(), 80,50,50,50)
    ;     Resize(Root(), 90,50,50,50)
    
    Bind( widget, @Events())
    
    WaitClose( )
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = --
; EnableXP