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
        Disable( *CHILD, 0 )
        Disable( *enable, 1 )
        If Disable( *disable )
          Disable( *disable, 0 )
        EndIf
        
      Case *disable
        Debug "disable"
        Disable( *CHILD, 1 )
        Disable( *disable, 1 )
        If Disable( *enable )
          Disable( *enable, 0 )
        EndIf
        
      Case *LIST
        Select WidgetEvent( )
          Case #__Event_Change
            If *CHILD
              FreeWidget(*CHILD)
            EndIf
            
            Select GetState(*LIST)
              Case  1: *CHILD = ButtonWidget(30,20,150,30,"Button") 
              Case  2: *CHILD = StringWidget(30,20,150,30,"String") 
              Case  3: *CHILD = TextWidget(30,20,150,30,"Text", #PB_Text_Border) 
              Case  4: *CHILD = Option(30,20,150,30,"Option") 
              Case  5: *CHILD = CheckBoxWidget(30,20,150,30,"CheckBox") 
              Case  6: *CHILD = ListViewWidget(30,20,150,30) 
              Case  7: *CHILD = FrameWidget(30,20,150,30,"Frame") 
              Case  8: *CHILD = ComboBoxWidget(30,20,150,30): AddItem(*CHILD,-1,"ComboBox"): SetState(*CHILD,0)
              Case  9: *CHILD = ImageWidget(30,20,150,30,0,#PB_Image_Border) 
              Case 10: *CHILD = HyperLinkWidget(30,20,150,30,"HyperLink",0) 
              Case 11: *CHILD = ContainerWidget(30,20,150,30,#PB_Container_Flat): ButtonWidget(0,0,80,20,"Button"): CloseWidgetList() ; Container
              Case 12: *CHILD = ListIconWidget(30,20,150,30,"",88) 
              ; Case 13: *CHILD = IPAddress(30,20,150,30) 
              Case 14: *CHILD = ProgressBarWidget(30,20,150,30,0,5)
              Case 15: *CHILD = ScrollBarWidget(30,20,150,30,5,335,9)
              Case 16: *CHILD = ScrollAreaWidget(30,20,150,30,305,305,9,#PB_ScrollArea_Flat): ButtonWidget(0,0,80,20,"Button"): CloseWidgetList()
              Case 17: *CHILD = TrackBarWidget(30,20,150,30,0,5)
                ;Case 18: *CHILD = Web(30,20,150,30,"") ; bug 531 linux
              Case 19: *CHILD = ButtonImageWidget(30,20,150,30,0)
                ;Case 20: *CHILD = Calendar(30,20,150,30) 
                ;Case 21: *CHILD = Date(30,20,150,30)
              Case 22: *CHILD = EditorWidget(30,20,150,30):  AddItem(*CHILD,-1,"Editor")
                ;Case 23: *CHILD = ExplorerListWidget(30,20,150,30,"")
                ;Case 24: *CHILD = ExplorerTreeWidget(30,20,150,30,"")
                ;Case 25: *CHILD = ExplorerCombo(30,20,150,30,"")
              Case 26: *CHILD = SpinWidget(30,20,150,30,0,5,#PB_Spin_Numeric)
              Case 27: *CHILD = TreeWidget(30,20,150,30):  AddItem(*CHILD,-1,"Tree"):  AddItem(*CHILD,-1,"SubLavel",0,1)
              Case 28: *CHILD = PanelWidget(30,20,150,30): AddItem(*CHILD,-1,"Panel"): CloseWidgetList()
              Case 29 
                *CHILD = SplitterWidget(30,20,150,30,ButtonWidget(0,0,30,30,"1"),ButtonWidget(0,0,30,30,"2"))
                
              Case 30: *CHILD = MDIWidget(30,10,150,70)
                ; Case 31: *CHILD = Scintilla(30,10,150,70,0)
                ; Case 32: *CHILD = Shortcut(30,10,150,70,0)
                ; Case 33: *CHILD = Canvas(30,10,150,70) 
            EndSelect
            
            ResizeWidget(*CHILD,10,40, 280, 150)
            
            Disable( *CHILD, 1  )
            Disable( *disable, 1 )
            If Disable( *enable )
              Disable( *enable, 0 )
            EndIf
        EndSelect
        
    EndSelect
 EndProcedure
  
  If OpenRootWidget(#PB_Any, 0, 0, 450, 200, "Disable-demo", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    *item1 = ButtonWidget( 10, 10, 50, 25, "item-1") : SetWidgetClass( *item1, "button-item-1" )
    *item2 = ButtonWidget( 60, 10, 50, 25, "item-2") : SetWidgetClass( *item2, "button-item-2" )
    *item3 = ButtonWidget( 110, 10, 50, 25, "item-3") : SetWidgetClass( *item3, "button-item-3" )
    BindWidgetEvent( *item1, @events( ), #__event_LeftDown )
    BindWidgetEvent( *item2, @events( ), #__event_LeftDown )
    BindWidgetEvent( *item3, @events( ), #__event_LeftDown )
    
    *disable = ButtonWidget( 180, 10, 50, 25, "disable") : SetWidgetClass( *disable, "button-disable" )
    *enable = ButtonWidget( 240, 10, 50, 25, "enable") : SetWidgetClass( *enable, "button-enable" )
    BindWidgetEvent( *enable, @events( ), #__event_LeftDown )
    BindWidgetEvent( *disable, @events( ), #__event_LeftDown )
    
    ;*LIST = ComboBoxWidget(400-110,40,100,150) 
    *LIST = ListViewWidget(300,10,150,180) 
    BindWidgetEvent( *LIST, @events( ), #__event_Change )
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
    *CHILD = ButtonWidget(10,40, 280, 150,"Button") 
    Disable( *CHILD, 1 )
    Disable( *disable, 1 )
    
    WaitCloseRootWidget( )
  EndIf   
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 49
; FirstLine = 45
; Folding = --
; EnableXP
; DPIAware