; CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
;   IncludePath "/Users/as/Documents/GitHub/Widget/"
; CompilerElse
;   IncludePath "../../"
; CompilerEndIf

; XIncludeFile "module_macros.pbi"
; XIncludeFile "module_constants.pbi"
; XIncludeFile "module_structures.pbi"
; XIncludeFile "module_bar.pbi"
; XIncludeFile "module_text.pbi"
; XIncludeFile "module_editor.pbi"
; XIncludeFile "module_tree.pbi"
IncludePath "../../"
XIncludeFile "widgets.pbi"

UseModule Widget
Procedure Gadget(Window, X,Y,Width,Height, Flag)
  Open(Window, X,Y,Width,Height,"")
  ProcedureReturn Tree(0, 0, Width,Height, Flag)
EndProcedure


Procedure LoadIcons(IconNameList.S)
  Protected i.I
  Protected *ImageBuffer
  Protected ImageSize.I

  If OpenPack(0, #PB_Compiler_Home + "Themes/SilkTheme.zip")
    *ImageBuffer = AllocateMemory(1024)
    
    If ExaminePack(0)
      For i = 0 To CountString(IconNameList, "|")
        ImageSize = UncompressPackMemory(0, *ImageBuffer, MemorySize(*ImageBuffer),
          StringField(IconNameList, i + 1, "|"))
        
        If ImageSize > 0
          CatchImage(i, *ImageBuffer, ImageSize)
        EndIf
      Next i
    EndIf
    
    FreeMemory(*ImageBuffer)
  EndIf
EndProcedure

UsePNGImageDecoder()
UseZipPacker()

LoadIcons("folder.png|page_white.png")

If OpenWindow(0, 0, 0, 355, 180, "TreeGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  Open(0, 0, 0, 760, 310)
    
  *g=tree(10, 10, 160, 160)                                                 ; TreeGadget standard
  *g1=tree(180, 10, 160, 160, #PB_Tree_CheckBoxes | #PB_Tree_NoLines)       ; TreeGadget with Checkboxes + NoLines
  
  ;For ID = 0 To 1
      For a = 0 To 10
        ;*g=GetGadgetData(ID)
        AddItem(*g, -1, "Normal Item "+Str(a), 0, 0) ; if you want to add an image, use
        AddItem(*g, -1, "Node "+Str(a), -1, 0)        ; ImageID(x) as 4th parameter
        AddItem(*g, -1, "Sub-Item 1", -1, 1)    ; These are on the 1st sublevel
        AddItem(*g, -1, "Sub-Item 2", -1, 1)
        AddItem(*g, -1, "Sub-Item 3", -1, 1)
        AddItem(*g, -1, "Sub-Item 4", -1, 1)
        AddItem(*g, -1, "File "+Str(a), -1, 0) ; sublevel 0 again
      Next
       a=0
     For a = 0 To 10
        ;*g=GetGadgetData(ID)
        AddItem(*g1, -1, "Normal Item "+Str(a), 0, 0) ; if you want to add an image, use
        AddItem(*g1, -1, "Node "+Str(a), -1, 0)        ; ImageID(x) as 4th parameter
        AddItem(*g1, -1, "Sub-Item 1", -1, 1)    ; These are on the 1st sublevel
        AddItem(*g1, -1, "Sub-Item 2", -1, 1)
        AddItem(*g1, -1, "Sub-Item 3", -1, 1)
        AddItem(*g1, -1, "Sub-Item 4", -1, 1)
        AddItem(*g1, -1, "File "+Str(a), -1, 0) ; sublevel 0 again
      Next
    ;Next
    
    ReDraw(Root())
    
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = --
; EnableXP