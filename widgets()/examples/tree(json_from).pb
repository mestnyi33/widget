IncludePath "../"
XIncludeFile "tree().pb"
;XIncludeFile "widgets().pbi"


UseModule Tree
Global *w._s_widget

OpenWindow(0, 0, 0, 300, 500, "TreeGadget", #PB_Window_ScreenCentered | #PB_Window_SystemMenu)
  *w = GetGadgetData(Gadget(0, 10, 10, 280, 480, #__tree_AlwaysSelection))

Procedure FillTreeGadgetFromJSON(JSON.i, *widget._s_widget)
  ClearItems(*widget)
  *Array = JSONValue(JSON)
  NewList PrevArray.i()
  NewList PrevIndex.i()
  i.i = 0
  Level.i = 0
  
  If JSONType(*Array) = #PB_JSON_Array
    SetAttribute(*widget, #__tree_Collapsed, 1)
    
    n.i = JSONArraySize(*Array)
    While (i < n)
      Select (JSONType(GetJSONElement(*Array, i)))
        Case #PB_JSON_String
          AddItem(*widget, -1, GetJSONString(GetJSONElement(*Array, i)), #Null, Level)
          i + 1
        Case #PB_JSON_Array
          AddElement(PrevArray()) : PrevArray() = *Array
          AddElement(PrevIndex()) : PrevIndex() = i
          *Array = GetJSONElement(*Array, i)
          n.i = JSONArraySize(*Array)
          i = 0
          Level + 1
        Default
          i + 1
      EndSelect
      
      While (i = n) ; Close
        If (ListSize(PrevArray())) ; Go back to previous level
          *Array = PrevArray()
          DeleteElement(PrevArray())
          n.i = JSONArraySize(*Array)
          i = PrevIndex() + 1
          DeleteElement(PrevIndex())
          Level - 1
        Else ; No more levels to go back to
          Break
        EndIf
      Wend
    Wend
  EndIf
  
  
;   n = CountItems(*widget)
;   For i = 0 To n - 1
;     SetItemState(*widget, i, #PB_Tree_Expanded)
;   Next
EndProcedure

If ReadFile(1, GetTemporaryDirectory() + "tree.json")
  Input.s = ReadString(1, #PB_File_IgnoreEOL)
  If ParseJSON(0, Input)
    FillTreeGadgetFromJSON(0, *w)
  EndIf
  CloseFile(1)
EndIf

Repeat
Until WaitWindowEvent() = #PB_Event_CloseWindow
; IDE Options = PureBasic 5.71 LTS (MacOS X - x64)
; Folding = --
; EnableXP