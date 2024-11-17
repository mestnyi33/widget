XIncludeFile "../../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
   
   EnableExplicit
   UseWidgets( )
   
   Enumeration
      #window
   EndEnumeration
   
   Global i = 5,*g._S_WIDGET
   
   OpenWindow(#window, 0, 0, 300, 300, "string", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
   
   ;\\ Open Root
   Define *root._S_WIDGET = OpenRootWidget(#window, 10, 10, 300 - 20, 300 - 20): *root\class = "root": SetTextWidget(*root, "root")
   
   *g = StringWidget(10, 220, 200, 50, "string gadget text text 1234567890 text text long long very long", #PB_String_Password | #__flag_Textright)
   
   Procedure button_panel_events( )
      Select GetTextWidget( EventWidget( ) )
         Case "1"
            ResizeWidget(*g, #PB_Ignore, WidgetY(*g)-i, #PB_Ignore, WidgetHeight(*g)+i)
         Case "2"
            ResizeWidget(*g, #PB_Ignore, WidgetY(*g)+i, #PB_Ignore, WidgetHeight(*g)-i)
            
      EndSelect
   EndProcedure
   BindWidgetEvent(ButtonWidget( 220, 220, 25, 50, "1"), @button_panel_events( ), #__event_LeftClick )
   BindWidgetEvent(ButtonWidget( 220 + 25, 220, 25, 50, "2"), @button_panel_events( ), #__event_LeftClick )
   
   WaitCloseRootWidget( )
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 25
; FirstLine = 2
; Folding = -
; EnableXP