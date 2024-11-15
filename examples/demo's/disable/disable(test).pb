XIncludeFile "../../../widgets.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile ;= 100
  EnableExplicit
  UseWidgets( )
  Global *enable, *disable, *CHILD, *item1, *item2, *item3, *LIST
  
  Procedure events( )
    Select EventWidget( ) 
      Case *item1
        SetState( *CHILD, 0)
      Case *item2
        SetState( *CHILD, 1)
      Case *item3
        SetState( *CHILD, 2)
        
      Case *enable
        Debug "enable"
        DisableWidget( *CHILD, 0 )
        DisableWidget( *enable, 1 )
        If DisableWidget( *disable )
          DisableWidget( *disable, 0 )
        EndIf
        
      Case *disable
        Debug "disable"
        DisableWidget( *CHILD, 1 )
        DisableWidget( *disable, 1 )
        If DisableWidget( *enable )
          DisableWidget( *enable, 0 )
        EndIf
        
      Case *LIST
        Select WidgetEvent( )
          Case #__Event_Change
            If *CHILD
              Free(*CHILD)
            EndIf
            
            Select GetState(*LIST)
              Case  1: *CHILD = Button(30,20,150,30,"Button") 
              Case  2: *CHILD = String(30,20,150,30,"String") 
              Case  3: *CHILD = Text(30,20,150,30,"Text", #PB_Text_Border) 
              Case  4: *CHILD = Option(30,20,150,30,"Option") 
              Case  5: *CHILD = CheckBox(30,20,150,30,"CheckBox") 
              Case  6: *CHILD = ListView(30,20,150,30) 
              Case  7: *CHILD = Frame(30,20,150,30,"Frame") 
              Case  8: *CHILD = ComboBox(30,20,150,30): AddItem(*CHILD,-1,"ComboBox"): SetState(*CHILD,0)
              Case  9: *CHILD = Image(30,20,150,30,0,#PB_Image_Border) 
              Case 10: *CHILD = HyperLink(30,20,150,30,"HyperLink",0) 
              Case 11: *CHILD = Container(30,20,150,30,#PB_Container_Flat): Button(0,0,80,20,"Button"): CloseList() ; Container
              Case 12: *CHILD = ListIcon(30,20,150,30,"",88) 
              ; Case 13: *CHILD = IPAddress(30,20,150,30) 
              Case 14: *CHILD = Progress(30,20,150,30,0,5)
              Case 15: *CHILD = Scroll(30,20,150,30,5,335,9)
              Case 16: *CHILD = ScrollArea(30,20,150,30,305,305,9,#PB_ScrollArea_Flat): Button(0,0,80,20,"Button"): CloseList()
              Case 17: *CHILD = Track(30,20,150,30,0,5)
                ;Case 18: *CHILD = Web(30,20,150,30,"") ; bug 531 linux
              Case 19: *CHILD = ButtonImage(30,20,150,30,0)
                ;Case 20: *CHILD = Calendar(30,20,150,30) 
                ;Case 21: *CHILD = Date(30,20,150,30)
              Case 22: *CHILD = Editor(30,20,150,30):  AddItem(*CHILD,-1,"Editor")
                ;Case 23: *CHILD = ExplorerList(30,20,150,30,"")
                ;Case 24: *CHILD = ExplorerTree(30,20,150,30,"")
                ;Case 25: *CHILD = ExplorerCombo(30,20,150,30,"")
              Case 26: *CHILD = Spin(30,20,150,30,0,5,#PB_Spin_Numeric)
              Case 27: *CHILD = Tree(30,20,150,30):  AddItem(*CHILD,-1,"Tree"):  AddItem(*CHILD,-1,"SubLavel",0,1)
              Case 28: *CHILD = Panel(30,20,150,30): AddItem(*CHILD,-1,"Panel"): CloseList()
              Case 29 
                *CHILD = Splitter(30,20,150,30,Button(0,0,30,30,"1"),Button(0,0,30,30,"2"))
                
              Case 30: *CHILD = MDI(30,10,150,70)
                ; Case 31: *CHILD = Scintilla(30,10,150,70,0)
                ; Case 32: *CHILD = Shortcut(30,10,150,70,0)
                ; Case 33: *CHILD = Canvas(30,10,150,70) 
            EndSelect
            
            Resize(*CHILD,10,40, 280, 150)
            
            DisableWidget( *CHILD, 1  )
            DisableWidget( *disable, 1 )
            If DisableWidget( *enable )
              DisableWidget( *enable, 0 )
            EndIf
        EndSelect
        
    EndSelect
 EndProcedure
  
  If Open(#PB_Any, 0, 0, 450, 200, "Disable-demo", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    *item1 = Button( 10, 10, 50, 25, "item-1") : SetClass( *item1, "button-item-1" )
    *item2 = Button( 60, 10, 50, 25, "item-2") : SetClass( *item2, "button-item-2" )
    *item3 = Button( 110, 10, 50, 25, "item-3") : SetClass( *item3, "button-item-3" )
    Bind( *item1, @events( ), #__event_LeftDown )
    Bind( *item2, @events( ), #__event_LeftDown )
    Bind( *item3, @events( ), #__event_LeftDown )
    
    *disable = Button( 180, 10, 50, 25, "disable") : SetClass( *disable, "button-disable" )
    *enable = Button( 240, 10, 50, 25, "enable") : SetClass( *enable, "button-enable" )
    Bind( *enable, @events( ), #__event_LeftDown )
    Bind( *disable, @events( ), #__event_LeftDown )
    
    ;*LIST = ComboBox(400-110,40,100,150) 
    *LIST = ListView(300,10,150,180) 
    Bind( *LIST, @events( ), #__event_Change )
    AddItem(*LIST, -1, "Selected  to move")
    AddItem(*LIST, -1, "Button")
    AddItem(*LIST, -1, "String")
    AddItem(*LIST, -1, "Text")
    AddItem(*LIST, -1, "CheckBox")
    AddItem(*LIST, -1, "Option")
    AddItem(*LIST, -1, "ListView")
    AddItem(*LIST, -1, "Frame")
    AddItem(*LIST, -1, "ComboBox")
    AddItem(*LIST, -1, "Image")
    AddItem(*LIST, -1, "HyperLink")
    AddItem(*LIST, -1, "Container")
    AddItem(*LIST, -1, "ListIcon")
    AddItem(*LIST, -1, "IPAddress")
    AddItem(*LIST, -1, "ProgressBar")
    AddItem(*LIST, -1, "ScrollBar")
    AddItem(*LIST, -1, "ScrollArea")
    AddItem(*LIST, -1, "TrackBar")
    AddItem(*LIST, -1, "Web")
    AddItem(*LIST, -1, "ButtonImage")
    AddItem(*LIST, -1, "Calendar")
    AddItem(*LIST, -1, "Date")
    AddItem(*LIST, -1, "Editor")
    AddItem(*LIST, -1, "ExplorerList")
    AddItem(*LIST, -1, "ExplorerTree")
    AddItem(*LIST, -1, "ExplorerCombo")
    AddItem(*LIST, -1, "Spin")        
    AddItem(*LIST, -1, "Tree")         
    AddItem(*LIST, -1, "Panel")        
    AddItem(*LIST, -1, "Splitter")    
    AddItem(*LIST, -1, "MDI") 
    AddItem(*LIST, -1, "Scintilla") 
    AddItem(*LIST, -1, "Shortcut")  
    AddItem(*LIST, -1, "Canvas")    
    
    SetState(*LIST, #PB_GadgetType_Button)
    *CHILD = Button(10,40, 280, 150,"Button") 
    DisableWidget( *CHILD, 1 )
    DisableWidget( *disable, 1 )
    
    WaitClose( )
  EndIf   
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 144
; FirstLine = 117
; Folding = --
; EnableXP
; DPIAware