; http://forums.purebasic.com/english/viewtopic.php?p=590269&sid=485a0d196e6ddbb0f920c6de89285d59#p590269

DeclareModule Associated
  Declare Get( object.i, *key.String )
  Declare Remove( object.i, *key.String )
  Declare Set( object.i, *key.String, value.i )
  Declare Clear( object.i )
EndDeclareModule

Module Associated
  CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
    #OBJC_ASSOCIATION_ASSIGN = 0
    #OBJC_ASSOCIATION_RETAIN_NONATOMIC = 1
    #OBJC_ASSOCIATION_COPY_NONATOMIC = 3
    #OBJC_ASSOCIATION_RETAIN = 769
    #OBJC_ASSOCIATION_COPY = 771
  CompilerEndIf
  
  Procedure Get( object.i, *key.String )
    CompilerSelect #PB_Compiler_OS 
      CompilerCase #PB_OS_MacOS
        ProcedureReturn objc_getAssociatedObject_( object, *key\s ) 
        
      CompilerCase #PB_OS_Windows
        ProcedureReturn GetProp_( object, *key\s )
        
      CompilerCase #PB_OS_Linux
        g_object_get_data_(object, *key\s )
        
    CompilerEndSelect                                                                  
  EndProcedure
  
  Procedure Remove( object.i, *key.String )
    CompilerSelect #PB_Compiler_OS 
      CompilerCase #PB_OS_MacOS
        objc_setAssociatedObject_( object, *key\s, #Null, #OBJC_ASSOCIATION_ASSIGN ) 
        
      CompilerCase #PB_OS_Windows
        RemoveProp_( object, *key\s )
        
      CompilerCase #PB_OS_Linux
        g_object_set_data_(object, *key\s, #Null )
        
    CompilerEndSelect                                                                    
  EndProcedure
  
  Procedure Clear( object.i )
    CompilerSelect #PB_Compiler_OS 
      CompilerCase #PB_OS_MacOS
        objc_removeAssociatedObjects_( object )
        
      CompilerCase #PB_OS_Windows
        ;RemoveProp_( object, *key\s )
        
    CompilerEndSelect                                                                    
  EndProcedure
  
  Procedure Set( object.i, *key.String, value.i )
    CompilerSelect #PB_Compiler_OS 
      CompilerCase #PB_OS_MacOS
        objc_setAssociatedObject_( object, *key\s, value, #OBJC_ASSOCIATION_ASSIGN ) 
        
      CompilerCase #PB_OS_Windows
        SetProp_(object, *key\s, value )
        
      CompilerCase #PB_OS_Linux
        g_object_set_data_(object, *key\s, value )
        
    CompilerEndSelect                                                                   
  EndProcedure
EndModule

CompilerIf #PB_Compiler_IsMainFile
  CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
    If OpenWindow(0, 0, 0, 300, 300, "Resize me !", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_SizeGadget)
      
      Associated::Set( WindowID(0), @"dat0", 12345)
      Associated::Set( WindowID(0), @"dat1", 54321)
      Debug Associated::Get( WindowID(0), @"dat0")
      Debug Associated::Get( WindowID(0), @"dat1")
      
;       Associated::Remove( WindowID(0), @"___data")
;       Debug Associated::Get( WindowID(0), @"___data")
      
      
      Repeat
        Event = WaitWindowEvent()
      Until Event = #PB_Event_CloseWindow
    EndIf 
  CompilerEndIf
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = --
; EnableXP