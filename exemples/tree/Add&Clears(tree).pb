CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
  IncludePath "/Users/as/Documents/GitHub/Widget/"
CompilerElse
  IncludePath "../../"
CompilerEndIf

XIncludeFile "module_macros.pbi"
XIncludeFile "module_constants.pbi"
XIncludeFile "module_structures.pbi"
XIncludeFile "module_scroll.pbi"
XIncludeFile "module_text.pbi"
XIncludeFile "module_editor.pbi"
XIncludeFile "module_tree.pbi"

Global Dim info.s(8)
Global Dim lines.l(8)

info(0)=" This is a very long line - should be over 60 chars to test long lines "
info(1)=" This line should be around 20 chars "
info(2)=" Blank " ; empty
info(3)=" Blank " ; empty
info(4)=" Chapter "
info(5)=" Track "
info(6)=" Songname from compdisk "

info(7)=" Track "
lines(0)=56
lines(1)=1235
lines(2)=328
lines(3)=152
lines(4)=728
lines(5)=412
lines(6)=514
lines(7)=917

Procedure RePopulate(track)
  Protected t.s
  
  If lines(track)>0
    Time = ElapsedMilliseconds()
    ClearGadgetItems(1)
    For i=1 To lines(track)
      Title.s = Str(i)+ info(track) +Str(i)
      AddGadgetItem(1, -1, Title)
    Next
    
    t=Str(ElapsedMilliseconds()-Time)
    Time = ElapsedMilliseconds()
    
    *g=GetGadgetData(11)
    
    Tree::ClearItems(*g)
    Text::ReDraw(*g)
    ;WindowEvent()
    
    For i=1 To lines(track)
      Title.s = Str(i)+ info(track) +Str(i)
      Tree::AddItem(*g, -1, Title,-1)
    Next
    
    Text::ReDraw(*g)
    t+" - "+Str(ElapsedMilliseconds()-Time)
  EndIf
  SetWindowTitle(1, t.s)
EndProcedure

If OpenWindow(1, 450, 200, 445, 550, "Window_0", #PB_Window_SystemMenu|#PB_Window_SizeGadget|#PB_Window_MinimizeGadget|#PB_Window_TitleBar)
  
  TreeGadget(1, 5, 5, 215, 510, #PB_Tree_AlwaysShowSelection|#PB_Tree_NoButtons|#PB_Tree_NoLines)
  Tree::Gadget(11, 225, 5, 215, 510, #PB_Tree_AlwaysShowSelection|#PB_Tree_NoButtons|#PB_Tree_NoLines)
  ButtonGadget(2,340,520,100,24,"Start")
  
  track=0
  RePopulate(track)
  
  Repeat
    Select WaitWindowEvent()
      Case #PB_Event_CloseWindow
        Select EventWindow()
          Case 1
            CloseWindow(1)
            Break
        EndSelect
        
      Case #PB_Event_Timer
        If EventTimer() = 123
            track+1
            If track>7
              track=0
            EndIf
            RePopulate(track)
        EndIf
        
      Case #PB_Event_Gadget
        Select EventGadget()
          Case 2
            state!1
            If state
              AddWindowTimer(1,123,2250)
              SetGadgetText(2, "Stop")
            Else
              RemoveWindowTimer(1,123)
              SetGadgetText(2, "Start")
            EndIf
            
        EndSelect
    EndSelect
  ForEver
  
EndIf
; IDE Options = PureBasic 5.62 (MacOS X - x64)
; Folding = --
; EnableXP