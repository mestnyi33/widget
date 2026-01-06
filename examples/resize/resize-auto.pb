
IncludePath "../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
   Enumeration 
      #g_tree 
      #w_tree
      #g_splitter
      #g_splitter2
   EndEnumeration
   
   Global g, *g._s_WIDGET
   Procedure ResizeCallBack()
      ResizeGadget(g, #PB_Ignore, #PB_Ignore, WindowWidth(0)-40, WindowHeight(0)-40)
      ; Debug *g\width
   EndProcedure
   
   Procedure resize_event( )
      Debug "[resize] - " + EventWidget( )\class +"( "+ EventWidget( )\x +" "+ EventWidget( )\y +" "+ EventWidget( )\width +" "+ EventWidget( )\height +" ) "; + EventWidget( )\root\canvas\gadget
   EndProcedure
   
   If OpenWindow(0, 0, 0, 300, 300, "autosize", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered)
      SetWindowColor( 0, $ff00ff)
      BindEvent( #PB_Event_SizeWindow, @ResizeCallBack())
      ;
      g = GetCanvasGadget(Open(0, 20,20 ))
      SetColor(Root(), #PB_Gadget_BackColor, $ff00ff00)
      CloseGadgetList( )
      ; g = SplitterGadget(#PB_Any,20,20,260,260,g, TextGadget(-1,0,0,0,0,""), #PB_Splitter_Separator)
      
      ;*g = Window(0,0,0,0,"window", #PB_Window_SystemMenu|#__flag_autosize)
      ;*g = Tree(0,0,0,0, #__flag_autosize) : Define i : For i=0 To 15 : AddItem(widget(), -1, "943093029709234790237490623panel") : Next
      *g = Button(0,0,0,0,"button", #__flag_autosize)
      
      Bind(#PB_All, @resize_event( ), #__event_Resize )
      g = SplitterGadget(#PB_Any,20,20,260,260,g, TextGadget(-1,0,0,0,0,""), #PB_Splitter_Separator)
      Repeat
         Select WaitWindowEvent()   
            Case #PB_Event_CloseWindow
               CloseWindow(EventWindow()) 
               Break
         EndSelect
      ForEver
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.21 - C Backend (MacOS X - x64)
; CursorPosition = 1
; Folding = -
; EnableXP