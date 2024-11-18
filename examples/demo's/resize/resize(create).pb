
XIncludeFile "../../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   test_event_resize = 1
  ; test_draw_repaint = 1
   
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
   
   Macro MouseMoveX( )
      DesktopUnscaledX( mouse( )\x - mouse( )\delta\x )
   EndMacro
   
   Macro MouseMoveY( )
      DesktopUnscaledY( mouse( )\y - mouse( )\delta\y )
   EndMacro
   
   Procedure Events()
      Static DraggedGadget
      
      Protected eventobject = EventWidget( )
      
      Select WidgetEvent( )
         Case #__event_RightUp
            DisplayPopupBar( *menu, EventWidget( ), mouse( )\x, mouse( )\y )
               
         Case #__event_DragStart
            DraggedGadget = eventobject
            
         Case #__event_LeftUp
            DraggedGadget = 0
            
         Case #__event_ResizeBegin
            Debug ""+GetWidgetClass(eventobject) + " event( RESIZEBEGIN )" 
            
         Case #__event_Resize
            Debug ""+GetWidgetClass(eventobject) + " event( RESIZE )" 
            
         Case #__event_ResizeEnd
            Debug ""+GetWidgetClass(eventobject) + " event( RESIZEEND )" 
            
         Case #__event_MouseMove
            If DraggedGadget 
               ;Debug Root()\canvas\resizebeginwidget ;GetWidgetClass(DraggedGadget)
               ResizeWidget(DraggedGadget, MouseMoveX( ), MouseMoveY( ), #PB_Ignore, #PB_Ignore)
               ;Debug Root()\canvas\resizebeginwidget
            EndIf
            
      EndSelect
   EndProcedure
   
   Procedure CreateWidget( *type )
      Protected result, X=50, Y=50, Width = 400, Height = 300, flags ;= #__flag_autosize
      
      Select *type
         Case  1: result = ButtonWidget(X,Y,Width,Height,"Button", flags) 
         Case  2: result = StringWidget(X,Y,Width,Height,"String", flags) 
         Case  3: result = TextWidget(X,Y,Width,Height,"Text", #PB_Text_Border|flags) 
         Case  4: result = OptionWidget(X,Y,Width,Height,"Option", flags) 
         Case  5: result = CheckBoxWidget(X,Y,Width,Height,"CheckBox", flags) 
         Case  6: result = ListViewWidget(X,Y,Width,Height, flags) 
         Case  7: result = FrameWidget(X,Y,Width,Height,"Frame", flags) 
         Case  8: result = ComboBoxWidget(X,Y,Width,Height, flags): AddItem(result,-1,"ComboBox"): SetWidgetState(result,0)
         Case  9: result = ImageWidget(X,Y,Width,Height,0,#PB_Image_Border|flags) 
         Case 10: result = HyperLinkWidget(X,Y,Width,Height,"HyperLink",0, flags) 
         Case 11: result = ContainerWidget(X,Y,Width,Height,#PB_Container_Flat|flags): ButtonWidget(0,0,80,Y,"Button1"):SetWidgetClass(widget(),GetWidgetText(widget())): ButtonWidget(10,50,80,Y,"Button2"):SetWidgetClass(widget(),GetWidgetText(widget())): CloseWidgetList() ; Container
         Case 12: result = ListIconWidget(X,Y,Width,Height,"",88, flags) 
            ;Case 13: result = IPAddress(x,y,width,height) 
            ;Case 14: result = ProgressBar(x,y,width,height,0,5)
            ;Case 15: result = ScrollBar(x,y,width,height,5,335,9)
         Case 16: result = ScrollAreaWidget(X,Y,Width,Height,Width*2,Height*2,9,#PB_ScrollArea_Flat|flags): ButtonWidget(0,0,80,30,"Button"): CloseWidgetList()
            ;Case 17: result = TrackBar(x,y,width,height,0,5)
            ;Case 18: result = Web(x,y,width,height,"") ; bug 531 linux
         Case 19: result = ButtonImageWidget(X,Y,Width,Height,0, flags)
            ;Case 20: result = Calendar(x,y,width,height) 
            ;Case 21: result = Date(x,y,width,height)
         Case 22: result = EditorWidget(X,Y,Width,Height, flags):  AddItem(result,-1,"Editor")
            ;Case 23: result = ExplorerListWidget(x,y,width,height,"")
            ;Case 24: result = ExplorerTreeWidget(x,y,width,height,"")
            ;Case 25: result = ExplorerCombo(x,y,width,height,"")
         Case 26: result = SpinWidget(X,Y,Width,Height,0,5,#PB_Spin_Numeric|flags)
         Case 27: result = TreeWidget(X,Y,Width,Height, flags) :  AddItem(result,-1,"Tree"):  AddItem(result,-1,"SubLavel",0,1)
         Case 28: result = PanelWidget(X,Y,Width,Height, flags): AddItem(result,-1,"Panel"): CloseWidgetList()
         Case 29 
            result = SplitterWidget(X,Y,Width,Height,ButtonWidget(0,0,0,0,"1"),ButtonWidget(0,0,0,0,"2"), flags)
            
         Case Height: result = MDIWidget(X,Y,Width,Height, flags)
            ; Case 31: result = Scintilla(x,y,width,height,0, flags)
            ; Case 32: result = Shortcut(x,y,width,height,0, flags)
            ; Case 33: result = Canvas(x,y,width,height, flags) 
      EndSelect
      
      ProcedureReturn result
   EndProcedure
   
   If OpenRoot(10, 0, 0, 500, 400, "Example 1: Creation of a basic objects.", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      SetWidgetColor(root(), #__color_back, RGBA(244, 245, 233, 255))
      SetWidgetClass(root( ), "[main-root]" )
      ;a_init( root())
      
; ;       ;\\
;       *menu = CreateBar( root( ) ) : SetWidgetClass(widget( ), "root_MenuBar" )
;       SetWidgetColor( *menu, #__color_back, $FFF7FEE2 )
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
;       BindWidgetEvent(*menu, @TestHandler(), -1, 7)
;       BindWidgetEvent(*menu, @QuitHandler(), -1, 8)
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
      Define widget = CreateWidget( #PB_GadgetType_Container )
      ;     ; CreateWidget( #PB_GadgetType_Editor )
      ;     ResizeWidget(Root(), 50,50,50,50)
      ;     ResizeWidget(Root(), 60,50,50,50)
      ;     ResizeWidget(Root(), 70,50,50,50)
      ;     ResizeWidget(Root(), 80,50,50,50)
      ;     ResizeWidget(Root(), 90,50,50,50)
      
      
      ;ResizeWidget(widget, 50,50,150,150)
      
      ;BindWidgetEvent( widget, @Events())
      BindWidgetEvent( #PB_All, @Events())
      
      WaitCloseRoot( )
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 71
; FirstLine = 67
; Folding = --
; EnableXP
; DPIAware