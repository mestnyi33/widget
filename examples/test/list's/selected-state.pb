; 
; demo state

IncludePath "../../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   Global Tree, Button
   
   Procedure ButtonClickEvent()
      Static count 
      AddItem(Tree, 1, "Added #"+count+"1", 0, 0)
      AddItem(Tree, 2, "Added #"+count+"2", 0, 1)
      AddItem(Tree, 3, "Added #"+count+"3", 0, 1)
      
      ; Debug GetState(Tree) ; 3
      SetActive(Tree)                                           
      SetState(Tree, 1)
      
      If GetState(Tree) = 1
         Debug "Added #"+count+"1 is selected, but you don't see it!"
         Debug "Try to select Added #1 with the mouse, you will not see anything"
      EndIf
      count + 1
   EndProcedure
   
   Open(0, 0, 0, 300, 300, "", #PB_Window_SystemMenu)
   Tree = Tree(5, 5, 290, 260)
   Button = Button(25, 270, 120, 24, "Add Item")
   
   AddItem(Tree, -1, "Item 1", 0, 0)
   AddItem(Tree, -1, "Item 2", 0, 0)
   AddItem(Tree, -1, "Item 3", 0, 1)
   AddItem(Tree, -1, "Item 4", 0, 1)
   
   SetItemState(Tree, 1, #PB_Tree_Expanded)
   
   Bind( Button, @ButtonClickEvent(), #__event_LeftClick )
   WaitClose( )
CompilerEndIf
; IDE Options = PureBasic 6.20 (Windows - x64)
; CursorPosition = 22
; FirstLine = 2
; Folding = -
; EnableXP
; DPIAware