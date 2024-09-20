
XIncludeFile "../../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   Uselib( WIDGET )
   test_event_resize = 1
   test_draw_repaint = 1
   
   Global *menu
   
   Procedure TestHandler()
      ;ClearDebugOutput()
      Debug "Test menu event"
   EndProcedure
   
   Procedure QuitHandler()
      ;ClearDebugOutput()
      Debug "Quit menu event"
      ; End
   EndProcedure
   
   Procedure Events()
      Static DraggedGadget
      
      Protected eventobject = EventWidget( )
      
      Select WidgetEventType( )
         Case #__event_RightButtonUp
            DisplayPopupMenuBar( *menu, EventWidget( ), mouse( )\x, mouse( )\y )
               
         Case #__event_DragStart
            DraggedGadget = eventobject
            
         Case #__event_LeftButtonUp
            DraggedGadget = 0
            
         Case #__event_ResizeBegin
            Debug ""+GetClass(eventobject) + " event( RESIZEBEGIN )" 
            
         Case #__event_Resize
            Debug ""+GetClass(eventobject) + " event( RESIZE )" 
            
         Case #__event_ResizeEnd
            Debug ""+GetClass(eventobject) + " event( RESIZEEND )" 
            
         Case #__event_MouseMove
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
         Case 11: result = Container(x,y,width,height,#PB_Container_Flat|flags): Button(0,0,80,y,"Button1"):SetClass(widget(),GetText(widget())): Button(10,50,80,y,"Button2"):SetClass(widget(),GetText(widget())): CloseList() ; Container
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
   
   If Open(10, 0, 0, 500, 400, "Example 1: Creation of a basic objects.", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      SetColor(root(), #__color_back, RGBA(244, 245, 233, 255))
      SetClass(root( ), "[main-root]" )
      ;a_init( root())
      
;       ;\\
      *menu = CreateMenuBar( root( ) ) : SetClass(widget( ), "root_MenuBar" )
      SetColor( *menu, #__color_back, $FFF7FEE2 )
      
      BarTitle("Title-1")
      BarItem(1, "title-1-item-1")
      BarSeparator( )
      
      OpenBar("title-1-sub-item")
      BarItem(3, "title-1-item")
      BarSeparator( )
      ;
      OpenBar("title-2-sub-item")   
      BarItem(13, "title-2-item")
      BarSeparator( )
      ;
      OpenBar("title-3-sub-item")   
      BarItem(23, "title-3-item")
      CloseBar( ) 
      ;
      BarSeparator( )
      BarItem(14, "title-2-item")
      CloseBar( ) 
      ;
      BarSeparator( )
      BarItem(4, "title-1-item")
      CloseBar( ) 
      ;
      BarSeparator( )
      BarItem(2, "title-1-item-2")
      
      BarTitle("Title-(no_items)")
      
      BarTitle("Title-(event_test)")
      BarItem(7, "test")
      BarSeparator( )
      BarItem(8, "quit")
      
      BarTitle("Title-4")
      BarItem(9, "item-1(4)")
      BarItem(10, "item-2(4)")
      
      Bind(*menu, @TestHandler(), -1, 7)
      Bind(*menu, @QuitHandler(), -1, 8)
      ;
      *menu = CreatePopupMenuBar( )
      If *menu                  ; creation of the pop-up menu begins...
         BarItem(1, "Open")     ; You can use all commands for creating a menu
         BarItem(2, "Save")     ; just like in a normal menu...
         BarItem(3, "Save as")
         BarItem(4, "Quit")
         BarSeparator( )
         OpenBar("Recent files")
         BarItem(5, "PureBasic.exe")
         BarItem(6, "Test.txt")
         CloseBar( )
      EndIf
      
      Define widget = CreateWidget( #PB_GadgetType_Container )
      ;     ; CreateWidget( #PB_GadgetType_Editor )
      ;     Resize(Root(), 50,50,50,50)
      ;     Resize(Root(), 60,50,50,50)
      ;     Resize(Root(), 70,50,50,50)
      ;     Resize(Root(), 80,50,50,50)
      ;     Resize(Root(), 90,50,50,50)
      
      ;Bind( widget, @Events())
      Bind( #PB_All, @Events())
      
      WaitClose( )
   EndIf
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (Windows - x64)
; CursorPosition = 100
; FirstLine = 49
; Folding = -+
; EnableXP