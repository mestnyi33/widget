IncludePath "../../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
  UseWidgets( )
  
  Global Panel =- 1
  Global first1=-1,prev1=-1,next1=-1,last1=-1
  Global first2=-1,prev2=-1,next2=-1,last2=-1
  Global first3=-1,prev3=-1,next3=-1,last3=-1
  
  Procedure _Event( )
    Select WidgetEvent( )
      Case #PB_EventType_LeftClick 
        Select EventWidget( )
          Case first1, first2, first3
            SetPosition( EventWidget( ), #PB_List_First)
          Case prev1, prev2, prev3
            SetPosition( EventWidget( ), #PB_List_Before)
          Case next1, next2, next3
            SetPosition( EventWidget( ), #PB_List_After)
          Case last1, last2, last3
            SetPosition( EventWidget( ), #PB_List_Last)
        EndSelect
        
        ClearDebugOutput( )
        ;debug_position( )
    EndSelect
    
  EndProcedure
  
  
  If Open(OpenWindow(#PB_Any, 0,0, 250,160, "Demo Z-Order", #PB_Window_ScreenCentered))
    
    Panel = PanelWidget(30,30,190,100);, "0")                                                               ;
    AddItem(Panel, -1, "tab_1")
    last1 = ButtonWidget(110,30,50,35, "last1") : SetWidgetClass(widget(), GetTextWidget(widget()))                                                               ;
    next1 = ButtonWidget(70,30,50,35, "next1") : SetWidgetClass(widget(), GetTextWidget(widget()))                                                                ;
    prev1 = ButtonWidget(30,30,50,35, "prev1") : SetWidgetClass(widget(), GetTextWidget(widget()))                                                                ;
    first1 = ButtonWidget(10,10,170,35, "first1") : SetWidgetClass(widget(), GetTextWidget(widget()))                                                             ;
    
    AddItem(Panel, -1, "tab_2") 
    last2 = ButtonWidget(110,30,50,35, "last2") : SetWidgetClass(widget(), GetTextWidget(widget()))                                                               ;
    next2 = ButtonWidget(70,30,50,35, "next2") : SetWidgetClass(widget(), GetTextWidget(widget()))                                                                ;
    prev2 = ButtonWidget(30,30,50,35, "prev2") : SetWidgetClass(widget(), GetTextWidget(widget()))                                                                ;
    first2 = ButtonWidget(10,10,170,35, "first2") : SetWidgetClass(widget(), GetTextWidget(widget()))                                                             ;
    
    AddItem(Panel, -1, "tab_3")
    last3 = ButtonWidget(110,30,50,35, "last3") : SetWidgetClass(widget(), GetTextWidget(widget()))                                                               ;
    next3 = ButtonWidget(70,30,50,35, "next3") : SetWidgetClass(widget(), GetTextWidget(widget()))                                                                ;
    prev3 = ButtonWidget(30,30,50,35, "prev3") : SetWidgetClass(widget(), GetTextWidget(widget()))                                                                ;
    first3 = ButtonWidget(10,10,170,35, "first3") : SetWidgetClass(widget(), GetTextWidget(widget()))                                                             ;
    
    CloseList()
    
    ;debug_position(root())
    SetState(Panel, 1)
    Bind(#PB_All, @_Event())
    
    WaitClose()
  EndIf
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 12
; FirstLine = 8
; Folding = -
; EnableXP
; DPIAware