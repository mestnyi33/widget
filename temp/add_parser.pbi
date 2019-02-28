Procedure Add(*Parser.Parser_S) ; Ok
  Protected GetParent, OpenGadgetList, Object=-1
  Static AddGadget
  
  With *Parser
    ;
    Select \Type\s
      Case "Window"        : \Type\i.i = #PB_GadgetType_Window        : \Object\i.i = Window        (\X\i.i,\Y\i.i,\Width\i.i,\Height\i.i, \Caption\s.s, \Flag\i.i, \Param1\i.i)
      Case "Button"        : \Type\i.i = #PB_GadgetType_Button        : \Object\i.i = Button        (\X\i.i,\Y\i.i,\Width\i.i,\Height\i.i, \Caption\s.s, \Flag\i.i)
      Case "String"        : \Type\i.i = #PB_GadgetType_String        : \Object\i.i = String        (\X\i.i,\Y\i.i,\Width\i.i,\Height\i.i, \Caption\s.s, \Flag\i.i)
      Case "Text"          : \Type\i.i = #PB_GadgetType_Text          : \Object\i.i = Text          (\X\i.i,\Y\i.i,\Width\i.i,\Height\i.i, \Caption\s.s, \Flag\i.i)
      Case "CheckBox"      : \Type\i.i = #PB_GadgetType_CheckBox      : \Object\i.i = CheckBox      (\X\i.i,\Y\i.i,\Width\i.i,\Height\i.i, \Caption\s.s, \Flag\i.i)
      Case "Option"        : \Type\i.i = #PB_GadgetType_Option        : \Object\i.i = Option        (\X\i.i,\Y\i.i,\Width\i.i,\Height\i.i, \Caption\s.s)
      Case "ListView"      : \Type\i.i = #PB_GadgetType_ListView      : \Object\i.i = ListView      (\X\i.i,\Y\i.i,\Width\i.i,\Height\i.i, \Flag\i.i)
      Case "Frame"         : \Type\i.i = #PB_GadgetType_Frame         : \Object\i.i = Frame         (\X\i.i,\Y\i.i,\Width\i.i,\Height\i.i, \Caption\s.s, \Flag\i.i)
      Case "ComboBox"      : \Type\i.i = #PB_GadgetType_ComboBox      : \Object\i.i = ComboBox      (\X\i.i,\Y\i.i,\Width\i.i,\Height\i.i, \Flag\i.i)
      Case "Image"         : \Type\i.i = #PB_GadgetType_Image         : \Object\i.i = Image         (\X\i.i,\Y\i.i,\Width\i.i,\Height\i.i, \Param1\i.i, \Flag\i.i)
      Case "HyperLink"     : \Type\i.i = #PB_GadgetType_HyperLink     : \Object\i.i = HyperLink     (\X\i.i,\Y\i.i,\Width\i.i,\Height\i.i, \Caption\s.s, \Param1\i.i, \Flag\i.i)
      Case "Container"     : \Type\i.i = #PB_GadgetType_Container     : \Object\i.i = Container     (\X\i.i,\Y\i.i,\Width\i.i,\Height\i.i, \Flag\i.i)
      Case "ListIcon"      : \Type\i.i = #PB_GadgetType_ListIcon      : \Object\i.i = ListIcon      (\X\i.i,\Y\i.i,\Width\i.i,\Height\i.i, \Caption\s.s, \Param1\i.i, \Flag\i.i)
      Case "IPAddress"     : \Type\i.i = #PB_GadgetType_IPAddress     : \Object\i.i = IPAddress     (\X\i.i,\Y\i.i,\Width\i.i,\Height\i.i)
      Case "ProgressBar"   : \Type\i.i = #PB_GadgetType_ProgressBar   : \Object\i.i = ProgressBar   (\X\i.i,\Y\i.i,\Width\i.i,\Height\i.i, \Param1\i.i, \Param2\i.i, \Flag\i.i)
      Case "ScrollBar"     : \Type\i.i = #PB_GadgetType_ScrollBar     : \Object\i.i = ScrollBar     (\X\i.i,\Y\i.i,\Width\i.i,\Height\i.i, \Param1\i.i, \Param2\i.i, \Param3\i.i, \Flag\i.i)
      Case "ScrollArea"    : \Type\i.i = #PB_GadgetType_ScrollArea    : \Object\i.i = ScrollArea    (\X\i.i,\Y\i.i,\Width\i.i,\Height\i.i, \Param1\i.i, \Param2\i.i, \Param3\i.i, \Flag\i.i) 
      Case "TrackBar"      : \Type\i.i = #PB_GadgetType_TrackBar      : \Object\i.i = TrackBar      (\X\i.i,\Y\i.i,\Width\i.i,\Height\i.i, \Param1\i.i, \Param2\i.i, \Flag\i.i)
      Case "Web"           : \Type\i.i = #PB_GadgetType_Web           : \Object\i.i = Web           (\X\i.i,\Y\i.i,\Width\i.i,\Height\i.i, \Caption\s.s)
      Case "ButtonImage"   : \Type\i.i = #PB_GadgetType_ButtonImage   : \Object\i.i = ButtonImage   (\X\i.i,\Y\i.i,\Width\i.i,\Height\i.i, \Param1\i.i, \Flag\i.i)
      Case "Calendar"      : \Type\i.i = #PB_GadgetType_Calendar      : \Object\i.i = Calendar      (\X\i.i,\Y\i.i,\Width\i.i,\Height\i.i, \Param1\i.i, \Flag\i.i)
      Case "Date"          : \Type\i.i = #PB_GadgetType_Date          : \Object\i.i = Date          (\X\i.i,\Y\i.i,\Width\i.i,\Height\i.i, \Caption\s.s, \Param1\i.i, \Flag\i.i)
      Case "Editor"        : \Type\i.i = #PB_GadgetType_Editor        : \Object\i.i = Editor        (\X\i.i,\Y\i.i,\Width\i.i,\Height\i.i, \Flag\i.i)
      Case "ExplorerList"  : \Type\i.i = #PB_GadgetType_ExplorerList  : \Object\i.i = ExplorerList  (\X\i.i,\Y\i.i,\Width\i.i,\Height\i.i, \Caption\s.s, \Flag\i.i)
      Case "ExplorerTree"  : \Type\i.i = #PB_GadgetType_ExplorerTree  : \Object\i.i = ExplorerTree  (\X\i.i,\Y\i.i,\Width\i.i,\Height\i.i, \Caption\s.s, \Flag\i.i)
      Case "ExplorerCombo" : \Type\i.i = #PB_GadgetType_ExplorerCombo : \Object\i.i = ExplorerCombo (\X\i.i,\Y\i.i,\Width\i.i,\Height\i.i, \Caption\s.s, \Flag\i.i)
      Case "Spin"          : \Type\i.i = #PB_GadgetType_Spin          : \Object\i.i = Spin          (\X\i.i,\Y\i.i,\Width\i.i,\Height\i.i, \Param1\i.i, \Param2\i.i, \Flag\i.i)
      Case "Tree"          : \Type\i.i = #PB_GadgetType_Tree          : \Object\i.i = Tree          (\X\i.i,\Y\i.i,\Width\i.i,\Height\i.i, \Flag\i.i)
      Case "Panel"         : \Type\i.i = #PB_GadgetType_Panel         : \Object\i.i = Panel         (\X\i.i,\Y\i.i,\Width\i.i,\Height\i.i) 
      Case "Splitter"      : \Type\i.i = #PB_GadgetType_Splitter      : \Object\i.i = Splitter      (\X\i.i,\Y\i.i,\Width\i.i,\Height\i.i, \Param1\i.i, \Param2\i.i, \Flag\i.i)
      Case "MDI"           : \Type\i.i = #PB_GadgetType_MDI           : \Object\i.i = MDI           (\X\i.i,\Y\i.i,\Width\i.i,\Height\i.i, \Param1\i.i, \Param2\i.i, \Flag\i.i) 
      Case "Scintilla"     : \Type\i.i = #PB_GadgetType_Scintilla     : \Object\i.i = Scintilla     (\X\i.i,\Y\i.i,\Width\i.i,\Height\i.i, \Param1\i.i)
      Case "Shortcut"      : \Type\i.i = #PB_GadgetType_Shortcut      : \Object\i.i = Shortcut      (\X\i.i,\Y\i.i,\Width\i.i,\Height\i.i, \Param1\i.i)
      Case "Canvas"        : \Type\i.i = #PB_GadgetType_Canvas        : \Object\i.i = Canvas        (\X\i.i,\Y\i.i,\Width\i.i,\Height\i.i, \Flag\i.i)
    EndSelect
    
    Select \Type\i
      Case #PB_GadgetType_Container, 
           #PB_GadgetType_Panel,
           #PB_GadgetType_ScrollArea, 
           #PB_GadgetType_Canvas
        EnableWindowDrop(\Object\i.i, #PB_Drop_Text, #PB_Drag_Copy)
    EndSelect
    
    ProcedureReturn \Object\i.i
  EndWith
EndProcedure


; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = 0
; EnableXP