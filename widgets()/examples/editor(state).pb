IncludePath "../"
XIncludeFile "editor().pbi"
;XIncludeFile "widgets().pbi"
UseModule editor
UseModule constants
UseModule structures

Global *w._s_widget

Procedure SetPos(Gadget, Position)
  CompilerSelect #PB_Compiler_OS
    CompilerCase #PB_OS_Linux
      If GadgetType( Gadget) = #PB_GadgetType_Editor
        Protected PositionIter.GtkTextIter
        Protected mark, *iter.GtkTextIter
        Protected *buffer = gtk_text_view_get_buffer_(GadgetID(Gadget))
        gtk_text_buffer_get_iter_at_offset_(*buffer, @PositionIter, Position)
        gtk_text_buffer_place_cursor_(*buffer, PositionIter)
        mark=gtk_text_buffer_create_mark_(*buffer,"cursor", PositionIter, #False);//create a mark in the buffer to scroll to
        gtk_text_view_scroll_to_mark_(GadgetID(Gadget),mark,0,#False,0,0)        ; //scroll to the mark
                                                                                 ; gtk_text_view_scroll_to_iter_(GadgetID(gadget), PositionIter, 0,#False,0,0)
        
      Else
        gtk_editable_set_position_( GadgetID(Gadget), Position )
      EndIf
      
    CompilerCase #PB_OS_MacOS
      Protected Range.NSRange : Range\location = Position
      CocoaMessage(0, GadgetID(Gadget), "setSelectedRange:@", @Range)
      CocoaMessage(0, GadgetID(Gadget), "scrollRangeToVisible:@", @Range)
      
    CompilerCase #PB_OS_Windows
      SendMessage_(GadgetID(Gadget), #EM_SETSEL, Position, Position)
      
  CompilerEndSelect
  
EndProcedure

If OpenWindow(0, 0, 0, 270, 270, "ListViewGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  EditorGadget(0, 10, 10, 250, 120)
  Gadget(1, 10, 140, 250, 120) : *w=GetGadgetData(1)
    
  For a = 1 To 12
    AddGadgetItem (0, -1, "Item " + Str(a) + " of the Listview") ; define listview content
  Next
  
  SetText(*w, "The" + #LF$ + "quick" + #LF$ + "brown" + #LF$ + "fox" + #LF$ + "jumps" + #LF$ + "over" + #LF$ + "the" + #LF$ + "lazy" + #LF$ + "dog."); + #LF$)
  For a = 1 To 12
    AddItem (*w, -1, "Item " + Str(a) + " of the Listview") ; define listview content
  Next
  
;   *w\text\string = Trim(*w\text\string, #LF$) ;+#LF$
;   *w\text\len = Len(*w\text\string)
  
  SetActiveGadget(0)
  SetPos(0, 98)
  
  SetActive(*w)
  SetItemState(*w,  4, 6) ; set caret pos   
  ;SetState(*w,  278) ; set caret pos   
  ;SetState(*w,  -1) ; set last pos   
  
  redraw(*w)
  Debug " get item - " + GetState(*w)
  Debug " get item caret pos - " + GetItemState(*w, GetState(*w))
  Debug " get text caret pos - " + GetItemState(*w, - 1)
  
  Repeat 
    event = WaitWindowEvent() 
    Select event
      Case #PB_Event_Gadget
        Select EventType()
          Case #PB_EventType_LeftClick
            ClearDebugOutput()
            Debug " get item - " + GetState(*w)
            Debug " get item caret pos - " + GetItemState(*w, GetState(*w))
            Debug " get text caret pos - " + GetItemState(*w, - 1)
            
        EndSelect
    EndSelect
  Until event = #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 5.70 LTS (Linux - x64)
; CursorPosition = 62
; FirstLine = 49
; Folding = -
; EnableXP