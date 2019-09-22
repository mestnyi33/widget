IncludePath "/Users/as/Documents/GitHub/Widget/"
XIncludeFile "_module_tree_12.pb"
;XIncludeFile "_module_tree_10_2.pb"
;XIncludeFile "_module_tree_7_1_0.pb"

UseModule Tree
Global *w._s_widget

OpenWindow(0, 0, 0, 300, 500, "TreeGadget", #PB_Window_ScreenCentered | #PB_Window_SystemMenu)
*w = Gadget(0, 10, 10, 280, 480, #PB_Flag_AlwaysSelection | #PB_Flag_Collapsed)
Additem(*w, -1, "Item 1", 0, 0)
Additem(*w, -1, "Folder A", 0, 0)
Additem(*w, -1, "Item 2", 0, 1)
Additem(*w, -1, "Folder B", 0, 1)
Additem(*w, 5, "Item 3", 0, 2)
Additem(*w, -1, "Item 4", 0, 0)
Additem(*w, -1, "Folder C", 0, 0)
Additem(*w, -1, "Item 5", 0, 1)
Additem(*w, -1, "Folder D", 0, 1)
Additem(*w, -1, "Item 6", 0, 2)
Additem(*w, -1, "Item 7", 0, 0)
        
; For i = 0 To CountItems(*w) - 1
;   SetItemState(*w, i, #PB_Tree_Expanded)
; Next

Procedure.i CreateJSONFromTreeGadget(JSON.i, *widget._s_widget)
  Protected Result.i = CreateJSON(JSON)
  
  If (Result)
    If (JSON = #PB_Any)
      JSON = Result
    EndIf
    
    *Array = SetJSONArray(JSONValue(JSON))
    NewList PrevArray.i()
    i.i = 0
    Level.i = 0
    
    n.i = CountItems(*widget)
    
    While (i < n)
      NewLevel.i = GetItemAttribute(*widget, i, #PB_Tree_SubLevel)
      
      While (NewLevel > Level) ; We're on a deeper sublevel, so insert a new array
        AddElement(PrevArray()) : PrevArray() = *Array
        *Array = AddJSONElement(*Array)
        SetJSONArray(*Array)
        Level + 1
      Wend
      
      While (NewLevel < Level) ; We're back to the parent sublevel, so return to that array
        *Array = PrevArray()
        DeleteElement(PrevArray())
        Level - 1
      Wend
      
      SetJSONString(AddJSONElement(*Array), GetItemText(*widget, i)) ; Add new item
      i + 1
    Wend
  EndIf
  
  ProcedureReturn (Result)
EndProcedure

If CreateJSONFromTreeGadget(0, *w)
  Output.s = ComposeJSON(0, #PB_JSON_PrettyPrint)
  Debug Output
  
  If CreateFile(1, GetTemporaryDirectory() + "tree.json")
    WriteString(1, Output)
    CloseFile(1)
  EndIf
EndIf

Repeat
Until WaitWindowEvent() = #PB_Event_CloseWindow
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = -
; EnableXP