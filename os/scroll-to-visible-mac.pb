EnableExplicit

#NumberOfColumns = 10
#NumberOfRows    = 10

Define ColumnIndex.I
Define RowIndex.I
Define RowText.S
Define SelectedGadget.I

OpenWindow(0, 200, 100, 346, 200, "ListIcon Example")
ListIconGadget(0, 10, 10, WindowWidth(0) - 20, 90, "Column 1", 100, #PB_ListIcon_GridLines)

For ColumnIndex = 2 To #NumberOfColumns
  AddGadgetColumn(0, ColumnIndex - 1, "Column " + Str(ColumnIndex), 100)
Next ColumnIndex

For RowIndex = 1 To #NumberOfRows
  RowText = ""

  For ColumnIndex = 1 To #NumberOfColumns
    RowText + "Row " + Str(RowIndex) + ", Col " + Str(ColumnIndex)

    If ColumnIndex < #NumberOfColumns
      RowText + #LF$
    EndIf
  Next ColumnIndex

  AddGadgetItem(0, -1, RowText)
Next RowIndex

SetGadgetState(0, -1)

SpinGadget(1, 80, GadgetY(0) + GadgetHeight(0) + 60, 45, 20, 1, #NumberOfRows, #PB_Spin_ReadOnly | #PB_Spin_Numeric)
SetGadgetState(1, 1)
SpinGadget(2, 220, GadgetY(0) + GadgetHeight(0) + 60, 45, 20, 1, #NumberOfColumns, #PB_Spin_ReadOnly | #PB_Spin_Numeric)
SetGadgetState(2, 1)
TextGadget(3, 30, GadgetY(0) + GadgetHeight(0) + 20, 130, 40, "Scroll row into visible area:", #PB_Text_Center)
TextGadget(4, 170, GadgetY(0) + GadgetHeight(0) + 20, 140, 40, "Scroll column into visible area:", #PB_Text_Center)

Repeat
  Select WaitWindowEvent()
    Case #PB_Event_CloseWindow
      Break
    Case #PB_Event_Gadget
      Select EventGadget()
        Case 1
          CocoaMessage(0, GadgetID(0), "scrollRowToVisible:", GetGadgetState(1) - 1)
        Case 2
          CocoaMessage(0, GadgetID(0), "scrollColumnToVisible:", GetGadgetState(2) - 1)
      EndSelect
  EndSelect
ForEver
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = -
; EnableXP