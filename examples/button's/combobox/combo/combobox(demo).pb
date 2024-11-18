 IncludePath "../../../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseWidgets( )
  
  Define a, w_x = 270, *w0, *w1, *w2
  UsePNGImageDecoder()
  LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/world.png")
  
  If OpenRoot(0, 0, 0, 270+w_x, 180, "ComboBox", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    ComboBoxGadget(0, 10, 10, 250, 21, #PB_ComboBox_Editable)
      AddGadgetItem(0, -1, "ComboBox editable...")

    ComboBoxGadget(1, 10, 40, 250, 21, #PB_ComboBox_Image)
      AddGadgetItem(1, -1, "ComboBox item with image", ImageID(0))

    ComboBoxGadget(2, 10, 70, 250, 21)
      For a = 1 To 5
        AddGadgetItem(2, -1,"ComboBox item " + Str(a))
      Next

    SetGadGetWidgetState(0, 0)
    SetGadGetWidgetState(1, 0)
    SetGadGetWidgetState(2, 2)    ; set (beginning with 0) the third item as active one
    
    *w0 = ComboBoxWidget(w_x+10, 10, 250, 21, #PB_ComboBox_Editable)
    AddItem(widget( ), -1, "ComboBox editable...")
    
    *w1 = ComboBoxWidget(w_x+10, 40, 250, 21, #PB_ComboBox_Image)
    AddItem(widget( ), -1, "ComboBox item with image", (0))
    
    *w2 = ComboBoxWidget(w_x+10, 70, 250, 21)
    For a = 1 To 5
      AddItem(widget( ), -1,"ComboBox item " + Str(a))
    Next
    
    SetWidgetState(*w0, 0)
    SetWidgetState(*w1, 0)
    SetWidgetState(*w2, 2)    ; set (beginning with 0) the third item as active one
    
    ;ButtonWidget(w_x+10, 70+20, 250, 21, "")
    
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 5
; FirstLine = 1
; Folding = -
; EnableXP