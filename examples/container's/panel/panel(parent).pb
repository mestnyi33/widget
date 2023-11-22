IncludePath "../../../"
CompilerIf #PB_Compiler_OS = #PB_OS_Windows
  XIncludeFile "include/os/win/id.pbi"
  XIncludeFile "include/os/win/ClipGadgets.pbi"
CompilerEndIf
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseLib(widget)
  
  Global i, x = 220, panel, butt1, butt2
  Global._s_WIDGET *root, *panel, *butt0, *butt1, *butt2
  
  If Open( #PB_Any, 0, 0, x+170, 170, "", #PB_Window_SystemMenu | #PB_Window_ScreenCentered )
    
   panel = PanelGadget(#PB_Any, 10, 65, 160,95 ) 
    For i = 0 To 5 
      AddGadgetItem( panel, i, Hex(i) ) 
      If i
        ButtonGadget(#PB_Any, 10,5,80,35, "_"+Str(i) ) 
      EndIf
    Next 
    CloseGadgetList( )
    
    OpenGadgetList( panel, 0 )
    ButtonGadget(#PB_Any, 10,5,80,35, "_0" ) 
    CloseGadgetList( )
    
    ;
    butt1 = ButtonGadget(#PB_Any, 10,5,80,25, "*butt1" ) 
    butt2 = ButtonGadget(#PB_Any, 10,35,80,25, "*butt2" ) 
    
    SetGadgetState( panel, 2 )
    
    *root = root()
;     ;*root = Window( x, 0, 160,170-10, "") :x = 0
;     *root = Container( x, 0, 160,170-10) :x = 0
    
    *panel = Panel( x, 65, 160,95 ) 
    For i = 0 To 5 
      AddItem( *panel, i, Hex(i) ) 
      If i
        Button( 10,5,80,35, "_"+Str(i) ) 
      EndIf
    Next 
    CloseList( )
    
;     OpenList( *panel, 2 )
;     Button( 20,25,80,35, "_0" ) 
;     CloseList( )
    
    *butt0 = Button( 20,25,80,35, "_0" )
    SetParent( *butt0, *panel, 0 )
    
    ;
    *butt1 = Button( x,5,80,25, "*butt1" ) 
    *butt2 = Button( x,35,80,25, "*butt2" ) 
    
    If *panel
      SetState( *panel, 2 )
    EndIf
    
    Debug "----panel all childrens-----"
    If StartEnumerate( *panel )
      Debug widget( )\text\string
      
      StopEnumerate( )
    EndIf
    
    Define line.s
    Debug "---->>"
    ForEach widget( )
      line = "  "+ widget( )\class +" "
      
      If widget( )\before\widget
        line + widget( )\before\widget\class+"_"+widget( )\before\widget\text\string +" <<  "
      Else
        line + "-------- <<  " 
      EndIf
      
      line + widget( )\text\string
      
      If widget( )\after\widget
        line +"  >> "+ widget( )\after\widget\class+"_"+widget( )\after\widget\text\string
      Else
        line + "  >> --------" 
      EndIf
      
      Debug line
    Next
    Debug "<<----"
    
    
    CompilerIf #PB_Compiler_OS = #PB_OS_Windows
      ClipGadgets( UseGadgetList(0) )
    CompilerEndIf
    Repeat: Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf   
CompilerEndIf
   
; IDE Options = PureBasic 5.73 LTS (Windows - x64)
; Folding = --
; EnableXP