EnableExplicit
; Изменение заголовка:
; QtScript(~"window("+w+").windowTitle = 'Новый заголовок'")
; Изменение видимости:
; QtScript(~"window("+w+").visible = false")
; Управление размером:
; QtScript(~"window("+w+").setFixedSize(400, 300)")
; Фокус ввода:
; QtScript(~"window("+w+").setFocus()")
; Прозрачность (Opacity):
; QtScript(~"window("+w+").setWindowOpacity(0.5)") 
; Qt Forum
; Qt Forum
; +2

Procedure SetTextWordWrap( g,s )
  QtScript(~"gadget("+g+").wordWrap = "+s+"")
EndProcedure

Procedure SetTextAlignment( g,s )
  QtScript(~"gadget("+g+").alignment = "+s+"") ; 0x0004|0x0080")
EndProcedure

Procedure DisableWindow_( w,s )
  QtScript(~"window("+w+").setDisabled("+s+")")
EndProcedure

Procedure SetWindowColor_( w,c )
  QtScript(~"window("+w+").styleSheet = " ~"\"background-color: #"+Hex(c)+~";\" ")
EndProcedure

Procedure SetParent( g,p )
  ;QtScript(~"gadget("+g+").setParent( gadget("+p+"))")
EndProcedure


  
If OpenWindow(0, 0, 0, 250, 200, "TextGadget Test", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  ButtonGadget(1, 10,10,150,50, "button")
  
  ContainerGadget(2, 50,50,100,100, #PB_Container_Flat)
  TextGadget(5, 10,10,80,80, "text wordwrap line")
  SetTextWordWrap(5, 1)
  SetTextAlignment(5, 1<<2|1<<7)
  
  CloseGadgetList()
  
  DisableWindow_(0, 1)
  SetWindowColor_(0, $FF66FF)
  SetParent( 1,2 )
  
  Repeat
    Define Event = WaitWindowEvent()
   
  Until Event = #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 6.30 - C Backend (MacOS X - x64)
; CursorPosition = 1
; Folding = --
; EnableXP
; SubSystem = qt