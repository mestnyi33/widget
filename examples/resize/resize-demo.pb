
XIncludeFile "../../widgets.pbi" 
;XIncludeFile "../../test.pbi" 

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   test_resize = 1
  test_resize_area = 2
   ; test_draw_repaint = 1
   ;test_clip = 1
   test_iclip = 1
   
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
   
   Procedure Callback()
      Static DraggedGadget
      
      Protected eventobject = EventWidget( )
      
      Select WidgetEvent( )
         Case #__event_RightUp
            DisplayPopupBar( *menu, EventWidget( ), CanvasMouseX( ), CanvasMouseY( ) )
               
         Case #__event_DragStart
            DraggedGadget = eventobject
            
         Case #__event_LeftUp
            DraggedGadget = 0
            
;          Case #__event_ResizeBegin
;             Debug ""+GetClass(eventobject) + " event( RESIZEBEGIN )" 
            
         Case #__event_Resize
            Debug ""+GetClass(eventobject) + " event( RESIZE )" 
            
;          Case #__event_ResizeEnd
;             Debug ""+GetClass(eventobject) + " event( RESIZEEND )" 
            
         Case #__event_MouseMove
            If DraggedGadget 
               ;Debug Root()\canvas\resizebeginwidget ;GetClass(DraggedGadget)
               Resize(DraggedGadget, MouseMoveX( ), MouseMoveY( ), #PB_Ignore, #PB_Ignore)
               ;Debug Root()\canvas\resizebeginwidget
            EndIf
            
      EndSelect
   EndProcedure
   
   Procedure CreateWidget( *type )
      Protected result, X=50, Y=50, Width = 400, Height = 300, flags ;= #__flag_autosize
      
      Select *type
         Case  1: result = Button(X,Y,Width,Height,"Button", flags) 
         Case  2: result = String(X,Y,Width,Height,"String", flags) 
         Case  3: result = Text(X,Y,Width,Height,"Text", #PB_Text_Border|flags) 
         Case  4: result = Option(X,Y,Width,Height,"Option", flags) 
         Case  5: result = CheckBox(X,Y,Width,Height,"CheckBox", flags) 
         Case  6: result = ListView(X,Y,Width,Height, flags) 
         Case  7: result = Frame(X,Y,Width,Height,"Frame", flags) 
         Case  8: result = ComboBox(X,Y,Width,Height, flags): AddItem(result,-1,"ComboBox"): SetState(result,0)
         Case  9: result = Image(X,Y,Width,Height,0,#PB_Image_Border|flags) 
         Case 10: result = HyperLink(X,Y,Width,Height,"HyperLink",0, flags) 
         Case 11: result = Container(X,Y,Width,Height,#PB_Container_Flat|flags)
            Button(0,0,80,60,"Button1"):SetClass(Widget(),GetText(Widget()))
            ;Button(10,50,80,Y,"Button2"):SetClass(widget(),GetText(widget()))
            ;Tree(110,50,80,60)
            Tree(0,0,0,0)
            Define i
            AddItem(Widget(), -1, Str(i)+"test item ")
            For i=1 To 5
               AddItem(Widget(), -1, Str(i)+"test item test item test item ")
            Next
            Debug "------"
            Resize(Widget(),110,50,80,60)
            
;             ScrollArea(200,50,80,60,150,150,1)
;             CloseList() ; ScrollArea
            CloseList() ; Container
            
         Case 12: result = ListIcon(X,Y,Width,Height,"",88, flags) 
            ;Case 13: result = IPAddress(x,y,width,height) 
            ;Case 14: result = ProgressBar(x,y,width,height,0,5)
            ;Case 15: result = ScrollBar(x,y,width,height,5,335,9)
         Case 16: result = ScrollArea(X,Y,Width,Height,Width*2,Height*2,9,#PB_ScrollArea_Flat|flags): Button(0,0,80,30,"Button"): CloseList()
            ;Case 17: result = TrackBar(x,y,width,height,0,5)
            ;Case 18: result = Web(x,y,width,height,"") ; bug 531 linux
         Case 19: result = ButtonImage(X,Y,Width,Height,0, flags)
            ;Case 20: result = Calendar(x,y,width,height) 
            ;Case 21: result = Date(x,y,width,height)
         Case 22: result = Editor(X,Y,Width,Height, flags):  AddItem(result,-1,"Editor")
            ;Case 23: result = ExplorerList(x,y,width,height,"")
            ;Case 24: result = ExplorerTree(x,y,width,height,"")
            ;Case 25: result = ExplorerCombo(x,y,width,height,"")
         Case 26: result = Spin(X,Y,Width,Height,0,5,#PB_Spin_Numeric|flags)
         Case 27: result = Tree(X,Y,Width,Height, flags) :  AddItem(result,-1,"Tree"):  AddItem(result,-1,"SubLavel",0,1)
         Case 28: result = Panel(X,Y,Width,Height, flags): AddItem(result,-1,"Panel"): CloseList()
         Case 29 
            result = Splitter(X,Y,Width,Height,Button(0,0,0,0,"1"),Button(0,0,0,0,"2"), flags)
            
         Case Height: result = MDI(X,Y,Width,Height, flags)
            ; Case 31: result = Scintilla(x,y,width,height,0, flags)
            ; Case 32: result = Shortcut(x,y,width,height,0, flags)
            ; Case 33: result = Canvas(x,y,width,height, flags) 
      EndSelect
      
      ProcedureReturn result
   EndProcedure
   
   If Open(10, 0, 0, 500, 400, "Example 1: Creation of a basic objects.", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      SetColor(Root(), #PB_Gadget_BackColor, RGBA(244, 245, 233, 255))
      SetClass(Root( ), "[main-root]" )
      a_init( Root())
      
; ;       ;\\
;       *menu = CreateBar( root( ) ) : SetClass(widget( ), "root_MenuBar" )
;       SetColor( *menu, #pb_gadget_backcolor, $FFF7FEE2 )
;       
;       BarTitle("Title-1")
;       BarItem(1, "title-1-item-1")
;       BarSeparator( )
;       
;       OpenSubBar("title-1-sub-item")
;       BarItem(3, "title-1-item")
;       BarSeparator( )
;       ;
;       OpenSubBar("title-2-sub-item")   
;       BarItem(13, "title-2-item")
;       BarSeparator( )
;       ;
;       OpenSubBar("title-3-sub-item")   
;       BarItem(23, "title-3-item")
;       CloseSubBar( ) 
;       ;
;       BarSeparator( )
;       BarItem(14, "title-2-item")
;       CloseSubBar( ) 
;       ;
;       BarSeparator( )
;       BarItem(4, "title-1-item")
;       CloseSubBar( ) 
;       ;
;       BarSeparator( )
;       BarItem(2, "title-1-item-2")
;       
;       BarTitle("Title-(no_items)")
;       
;       BarTitle("Title-(event_test)")
;       BarItem(7, "test")
;       BarSeparator( )
;       BarItem(8, "quit")
;       
;       BarTitle("Title-4")
;       BarItem(9, "item-1(4)")
;       BarItem(10, "item-2(4)")
;       
;       Bind(*menu, @TestHandler(), -1, 7)
;       Bind(*menu, @QuitHandler(), -1, 8)
;       ;
;       *menu = CreatePopupBar( )
;       If *menu                  ; creation of the pop-up menu begins...
;          BarItem(1, "Open")     ; You can use all commands for creating a menu
;          BarItem(2, "Save")     ; just like in a normal menu...
;          BarItem(3, "Save as")
;          BarItem(4, "Quit")
;          BarSeparator( )
;          OpenSubBar("Recent files")
;          BarItem(5, "PureBasic.exe")
;          BarItem(6, "Test.txt")
;          CloseSubBar( )
;       EndIf
;       
      Define Widget = CreateWidget( #PB_GadgetType_Container )
      ;     ; CreateWidget( #PB_GadgetType_Editor )
      ;     Resize(Root(), 50,50,50,50)
      ;     Resize(Root(), 60,50,50,50)
      ;     Resize(Root(), 70,50,50,50)
      ;     Resize(Root(), 80,50,50,50)
      ;     Resize(Root(), 90,50,50,50)
      
      
      ;Resize(widget, 50,50,150,150)
      
;       Debug "-----"
;       ;Bind( widget, @Callback())
;       Bind( #PB_All, @Callback())
      
      WaitClose( )
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.30 - C Backend (MacOS X - x64)
; CursorPosition = 48
; FirstLine = 32
; Folding = --
; EnableXP
; DPIAware