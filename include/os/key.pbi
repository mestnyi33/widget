
; --- ОБЪЯВЛЕНИЕ МОДУЛЯ ---
DeclareModule key
   Declare Set(handle.i, KeyName.s, Value.i)
   Declare.i Get(handle.i, KeyName.s)
   Declare Remove(handle.i, KeyName.s)
EndDeclareModule

; --- РЕАЛИЗАЦИЯ МОДУЛЯ ---
Module key
   EnableExplicit
   
   ; Блок импорта системных функций (вне модуля)
   CompilerSelect #PB_Compiler_OS
      CompilerCase #PB_OS_MacOS
         ImportC "";/usr/lib/libobjc.dylib"
            sel_registerName(str.p-ascii)
            objc_setAssociatedObject(obj.i, key.i, value.i, policy.i)
            objc_getAssociatedObject(obj.i, key.i)
         EndImport
      CompilerCase #PB_OS_Linux
         CompilerIf Subsystem("Qt")
            ; Импортируем нужные функции из библиотеки Qt
            ImportC "-lQt5Core" ; Для систем с Qt5 (стандарт для текущих версий PB)
                                ; QObject::setProperty(const char *name, const QVariant &value)
                                ; Мы упрощаем вызов, так как PB передает указатели
               q_object_set_property(obj.i, name.p-utf8, value.i) 
               q_object_get_property(obj.i, name.p-utf8)
            EndImport
         CompilerElse
            ImportC "-lglib-2.0"
               g_object_set_data(object.i, key.p-utf8, Data.i)
               g_object_get_data(object.i, key.p-utf8)
            EndImport
         CompilerEndIf
   CompilerEndSelect
   
   Procedure Set(handle.i, KeyName.s, Value.i)
      CompilerSelect #PB_Compiler_OS
         CompilerCase #PB_OS_Windows
            SetProp_(handle, KeyName, Value)
         CompilerCase #PB_OS_MacOS
            objc_setAssociatedObject(handle, sel_registerName(KeyName), Value, 0)
         CompilerCase #PB_OS_Linux
            g_object_set_data(handle, KeyName, Value)
      CompilerEndSelect
   EndProcedure
   
   Procedure.i Get(handle.i, KeyName.s)
      CompilerSelect #PB_Compiler_OS
         CompilerCase #PB_OS_Windows
            ProcedureReturn GetProp_(handle, KeyName)
         CompilerCase #PB_OS_MacOS
            ProcedureReturn objc_getAssociatedObject(handle, sel_registerName(KeyName))
         CompilerCase #PB_OS_Linux
            ProcedureReturn g_object_get_data(handle, KeyName)
      CompilerEndSelect
   EndProcedure
   
   Procedure Remove(handle.i, KeyName.s)
      CompilerSelect #PB_Compiler_OS
         CompilerCase #PB_OS_Windows
            RemoveProp_(handle, KeyName)
         CompilerDefault
            Set(handle, KeyName, 0)
      CompilerEndSelect
   EndProcedure
EndModule

CompilerIf #PB_Compiler_IsMainFile
   ; --- ПРИМЕР ---
   If OpenWindow(0, 0, 0, 200, 100, "key Test", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      ButtonGadget(1, 10, 10, 180, 30, "Нажми")
      
      ; Теперь функции видны через key::
      key::Set(GadgetID(1), "MyValue", 12345)
      
      Repeat
         Select WaitWindowEvent()
            Case #PB_Event_Gadget
               If EventGadget() = 1
                  Debug "Значение из гаджета: " + key::Get(GadgetID(1), "MyValue")
               EndIf
            Case #PB_Event_CloseWindow
               Break
         EndSelect
      ForEver
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.30 - C Backend (MacOS X - x64)
; CursorPosition = 81
; FirstLine = 55
; Folding = --
; EnableXP
; DPIAware