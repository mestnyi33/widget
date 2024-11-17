; 
; XIncludeFile "../../../widgets.pbi" : UseWidgets( )
; 
; CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
;     LoadFont(5, "Arial", 18)
;     LoadFont(6, "Arial", 25)
;     
;   CompilerElse
;     LoadFont(5, "Arial", 14)
;     LoadFont(6, "Arial", 21)
;     
;  CompilerEndIf
;  
; If OpenRootWidget(0, 0, 0, 322 + 322 + 100, 220, "PanelGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
;   
;   PanelWidget(8, 8, 356, 203)
;   ;BarPosition( widget()\TabBox( ), 1, 100 )
;   
;   AddItem (ID(0), -1, "Panel 1")
;   
;   AddItem (ID(0), -1,"Panel 2")
;   
;   AddItem (ID(0), -1,"Panel 3")
;  
;   CloseWidgetList()
;   
;    SetItemFont(ID(0), 1, 6)
;   ; SetItemFont(ID(0), 2, 6)
;   
;   Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
; EndIf


XIncludeFile "../../../widgets.pbi" 

   CompilerIf #PB_Compiler_IsMainFile 
   EnableExplicit
   UseWidgets( )
   
   Enumeration
      #window_0
      #window
   EndEnumeration
   
   Define i, *w._s_WIDGET
   
   CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
    LoadFont(5, "Arial", 18)
    LoadFont(6, "Arial", 25)
    
  CompilerElse
    LoadFont(5, "Arial", 14)
    LoadFont(6, "Arial", 21)
    
  CompilerEndIf
  
  
   ;\\
   OpenWindow(#window_0, 0, 0, 424, 352, "AnchorsGadget", #PB_Window_SystemMenu )
   
   Define *root._s_WIDGET = OpenRootWidget(#window_0, 0, 0, 424, 352): *root\class = "root": SetTextWidget(*root, "root")
   *w = EditorWidget( 10, 10, 424 - 20, 352 - 20) ; , #__flag_autosize )
   For i = 1 To 100;0000
      If (i & 2) 
         AddItem(*w, i, "text-" + Str(i), -1, 1 )
         ;SetItemFont(*w, i, 6)
      Else
         AddItem(*w, i, "text-" + Str(i))
      EndIf
   Next 
   i=0
   For i = 1 To 100;0000
      If (i & 2) 
         SetItemFont(*w, i, 6)
         ;Debug i
      EndIf
   Next
   ;\\Close( )
   
   ;\\
   OpenWindow(#window, 0, 0, 800, 600, "PanelGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
   
   ;\\ 
   Define *root0._s_WIDGET = OpenRootWidget(#window, 10, 10, 300 - 20, 300 - 20): *root0\class = "root0": SetTextWidget(*root0, "root0")
   *w = EditorWidget( 10, 10, 300 - 20, 300 - 20) ; , #__flag_autosize )
   For i = 1 To 100;0000
      If (i & 5)
         AddItem(*w, i, "text-" + Str(i), -1, 1 )
      Else
         AddItem(*w, i, "text-" + Str(i))
      EndIf
   Next
   SetFont(*w, 5)
   ;\\Close( )
   
   ;\\ 
   Define *root1._s_WIDGET = OpenRootWidget(#window, 300, 10, 300 - 20, 300 - 20): *root1\class = "root1": SetTextWidget(*root1, "root1")
   *w = EditorWidget( 10, 10, 300 - 20, 300 - 20) ; , #__flag_autosize )
   For i = 1 To 100;0000
      If (i & 5)
         AddItem(*w, i, "text-" + Str(i), -1, 1 )
      Else
         AddItem(*w, i, "text-" + Str(i))
      EndIf
   Next
   ;\\Close( )
   
   Define *root2._s_WIDGET = OpenRootWidget(#window, 10, 300, 300 - 20, 300 - 20): *root2\class = "root2": SetTextWidget(*root2, "root2")
   *w = EditorWidget( 10, 10, 300 - 20, 300 - 20) ; , #__flag_autosize )
   For i = 1 To 100;0000
      If (i & 5)
         AddItem(*w, i, "text-" + Str(i), -1, 1 )
      Else
         AddItem(*w, i, "text-" + Str(i))
      EndIf
   Next
   SetFont(*w, 5)
   ;\\Close( )
   
   
   Define *root3._s_WIDGET = OpenRootWidget(#window, 300, 300, 300 - 20, 300 - 20): *root3\class = "root3": SetTextWidget(*root3, "root3")
   *w = EditorWidget( 10, 10, 300 - 20, 300 - 20) ; , #__flag_autosize )
   For i = 1 To 100;0000
      If (i & 5)
         AddItem(*w, i, "text-" + Str(i), -1, 1 )
      Else
         AddItem(*w, i, "text-" + Str(i))
      EndIf
   Next
   SetFont(*w, 6)
   ;\\Close( )
   
   Define *root4._s_WIDGET = OpenRootWidget(#window, 590, 10, 200, 600 - 20): *root4\class = "root4": SetTextWidget(*root4, "root4")
   *w = EditorWidget( 10, 10, 200 - 20, 600 - 20) ; , #__flag_autosize )
   For i = 1 To 100;0000
      If (i & 5)
         AddItem(*w, i, "text-" + Str(i), -1, 1 )
      Else
         AddItem(*w, i, "text-" + Str(i))
      EndIf
   Next
   ;\\Close( )
   
   
   
   WaitCloseRootWidget( )
   
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 27
; FirstLine = 18
; Folding = --
; EnableXP
; DPIAware