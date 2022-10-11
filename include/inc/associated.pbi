DeclareModule Associated
  Declare Get( object.i, key.s )
  Declare Remove( object.i, key.s )
  Declare Set( object.i, key.s, value.i )
EndDeclareModule

Module Associated
  CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
    #OBJC_ASSOCIATION_ASSIGN = 0
    #OBJC_ASSOCIATION_RETAIN_NONATOMIC = 1
    #OBJC_ASSOCIATION_COPY_NONATOMIC = 3
    #OBJC_ASSOCIATION_RETAIN = 769
    #OBJC_ASSOCIATION_COPY = 771
  CompilerEndIf
  
  Procedure Get( object.i, key.s )
    CompilerSelect #PB_Compiler_OS 
      CompilerCase #PB_OS_MacOS
        ProcedureReturn objc_getAssociatedObject_( object, key ) 
        
      CompilerCase #PB_OS_Windows
        ProcedureReturn GetProp_( object, key )
        
    CompilerEndSelect                                                                  
  EndProcedure
  
  Procedure Remove( object.i, key.s )
    CompilerSelect #PB_Compiler_OS 
      CompilerCase #PB_OS_MacOS
        objc_setAssociatedObject_( object, key, #Null, #OBJC_ASSOCIATION_ASSIGN ) 
        ; objc_removeAssociatedObjects_(object )
        
      CompilerCase #PB_OS_Windows
        RemoveProp_( object, key )
        
    CompilerEndSelect                                                                    
  EndProcedure
  
  Procedure Set( object.i, key.s, value.i )
    CompilerSelect #PB_Compiler_OS 
      CompilerCase #PB_OS_MacOS
        objc_setAssociatedObject_( object, key, value, #OBJC_ASSOCIATION_ASSIGN ) 
        
      CompilerCase #PB_OS_Windows
        SetProp_(object, key, value )
        
    CompilerEndSelect                                                                   
  EndProcedure
EndModule

CompilerIf #PB_Compiler_IsMainFile
  CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
    ImportC ""
      objc_setAssociatedObject( object,    ; Any
                                key.s,     ; UnsafeRawPointer,
                                value,     ; Any?,
                                policy )   ; objc_AssociationPolicy 
      
      objc_getAssociatedObject( object,    ; Any
                                key.s )    ; UnsafeRawPointer
    EndImport
    
    If OpenWindow(0, 0, 0, 300, 300, "Resize me !", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_SizeGadget)
      Define key.s = "___data"
      Define key1.s = key ; "___data"
      
      objc_setAssociatedObject_( WindowID(0), key, 12345, 0 ) 
      Debug objc_getAssociatedObject_( WindowID(0), key1 ) 
      
      Repeat
        Event = WaitWindowEvent()
      Until Event = #PB_Event_CloseWindow
    EndIf 
  CompilerEndIf
CompilerEndIf

; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = --
; EnableXP