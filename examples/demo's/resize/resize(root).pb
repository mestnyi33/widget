
IncludePath "../../../"
;XIncludeFile "widgets.pbi"
XIncludeFile "widget-events.pbi"

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseLib(widget)
  
  Enumeration 
    #g_tree 
    #w_tree
    #g_splitter
    #g_splitter2
  EndEnumeration
  
  Procedure ResizeCallBack()
    ResizeGadget(#g_splitter, #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-16, WindowHeight(EventWindow(), #PB_Window_InnerCoordinate)-16)
    
    CompilerIf #PB_Compiler_Version =< 546
      PostEvent(#PB_Event_Gadget, EventWindow(), #w_tree, #PB_EventType_Resize)
    CompilerEndIf
  EndProcedure
  
  Procedure SplitterCallBack()
    PostEvent(#PB_Event_Gadget, EventWindow(), #w_tree, #PB_EventType_Resize)
  EndProcedure
  
  If OpenWindow(0, 0, 0, 300, 491, "TreeGadget", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered)
    ContainerGadget(#g_tree, 0,0,0,0, #PB_Container_Flat ) : CloseGadgetList( )                                      
    
    Open(0, 0,0,0,0, "", #Null, #Null, #w_tree )

    SplitterGadget(#g_splitter2, 0,0,0,0, #g_tree, #w_tree)
    SplitterGadget(#g_splitter, 8, 8, 300-16, 491-16, TextGadget(#PB_Any,0,0,0,0,""),#g_splitter2, #PB_Splitter_Vertical|#PB_Splitter_FirstFixed)
    
    
    CompilerIf #PB_Compiler_Version =< 546
      BindGadgetEvent(#g_splitter, @SplitterCallBack())
    CompilerEndIf
    
    ;PostEvent(#PB_Event_SizeWindow, 0, #PB_Ignore) ; Bug no linux
    ;BindEvent(#PB_Event_SizeWindow, @ResizeCallBack(), 0)
    
    Repeat
      Select WaitWindowEvent()   
        Case #PB_Event_CloseWindow
          CloseWindow(EventWindow()) 
          Break
      EndSelect
    ForEver
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = --
; EnableXP