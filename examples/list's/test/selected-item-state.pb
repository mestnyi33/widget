; 
; demo state

IncludePath "../../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   Global Tree, Button
   
   Procedure ButtonClickEvent()
      AddItem(Tree, 1, "Added #1", 0, 0)
      AddItem(Tree, 2, "Added #2", 0, 1)
      AddItem(Tree, 3, "Added #3", 0, 1)
      
      SetActive(Tree)                                           
      SetItemState(Tree, 1, #PB_Tree_Selected ) 
      
      If GetItemState(Tree, 1) & #PB_Tree_Selected
         Debug "Added #1 is selected, but you don't see it!"
         Debug "Try to select Added #1 with the mouse, you will not see anything"
      EndIf
      
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
; CursorPosition = 16
; FirstLine = 1
; Folding = -
; EnableXP
; DPIAware