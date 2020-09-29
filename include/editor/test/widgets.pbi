;XIncludeFile "../e.pbi" : #ver = 2
XIncludeFile "../e1.pbi" : #ver = 6

  UseModule PBEdit

Macro Uselib(_name_)
;   UseModule _name_
;   UseModule constants
;   UseModule structures
EndMacro

#__sOC = SizeOf(Character)
#__Flag_GridLines = 1<<1

Global canvas_gadget, canvas_window, canvas_x, canvas_y

Procedure Open(window,x,y,width,height)
  canvas_window = window
  canvas_x = x
  canvas_y = y
  
EndProcedure

Macro Root()
  canvas_window
EndMacro

Procedure Editor(x,y,width,height)   
  CompilerIf #ver = 6
    canvas_gadget = PBedit_Gadget(GetActiveWindow(), x+canvas_x,y+canvas_y,width,height)
    ProcedureReturn canvas_gadget 
  CompilerElse
    canvas_gadget = PBedit_Gadget(#PB_Any, GetActiveWindow(), x+canvas_x,y+canvas_y,width,height) ; ver 1.2
    ProcedureReturn PBEdit_EditorFromID(canvas_gadget)
  CompilerEndIf
EndProcedure

Procedure SetText(*this, text.s)
  ProcedureReturn PBEdit_SetText(canvas_gadget, text)
EndProcedure

Procedure SetState(*cursor._PBEdit_::TE_CURSOR, State)
;   Protected text.s ;= *this\text\string 
;   Protected length ;= *this\text\len
;   Protected caret_pos = *this\currentCursor\position ; *this\text\caret\pos
;   
;   If state < 0 Or state > length
;     state = length
;   EndIf
;   
;   If caret_pos <> State
;     caret_pos = State
;     
;     Protected i.l, len.l
;     Protected *str.Character = @text
;     Protected *end.Character = @text
;     
;     While *end\c 
;       If *end\c = #LF 
;         len + (*end - *str)/#__sOC
;         ; Debug "" + i + " " + Str(len + i)  + " " +  state
;         
;         If len + i >= state
; ;           *this\index[#__s_1] = i
; ;           *this\index[#__s_2] = i
; ;           
; ;           *this\text\caret\pos[1] = state - (len - (*end - *str)/#__sOC) - i
; ;           *this\text\caret\pos[2] = *this\text\caret\pos[1]
;           
;           Break
;         EndIf
;         i + 1
;         
;         *str = *end + #__sOC 
;       EndIf 
;       
;       *end + #__sOC 
;     Wend
; ;     
; ;     ; last line
; ;     If *this\index[#__s_1] <> i 
; ;       *this\index[#__s_1] = i
; ;       *this\index[#__s_2] = i
; ;       
; ;       *this\text\caret\pos[1] = (state - len - i) 
; ;       *this\text\caret\pos[2] = *this\text\caret\pos[1]
; ;     EndIf
; ;     
; ;     result = #True 
; ;   EndIf
  
  ProcedureReturn PBEdit_SetCurrentPosition(canvas_gadget, *cursor\position\charNr, *cursor\position\lineNr)
EndProcedure

Procedure SetItemState(*this, position, State)
  ProcedureReturn PBEdit_SetCurrentPosition(canvas_gadget, position, State)
EndProcedure

Procedure SetItemData(*this, position, *data)
  ;ProcedureReturn PBEdit_SetGadgetItemData(canvas_gadget, position, text)
EndProcedure

Procedure SetItemText(*this, position, text.s)
  ProcedureReturn PBEdit_SetGadgetItemtext(canvas_gadget, position, text)
EndProcedure

Procedure GetItemData(*this, position)
  ;ProcedureReturn PBEdit_SetGadgetItemData(canvas_gadget, position, text)
EndProcedure

Procedure.s GetItemText(*this, position)
  ProcedureReturn PBEdit_GetGadgetItemtext(canvas_gadget, position)
EndProcedure

Procedure AddItem(*this, position, text.s, image=-1, flag=0)
  ProcedureReturn PBEdit_AddGadgetItem(canvas_gadget, position, text)
EndProcedure

Procedure RemoveItem(*this, position)
  ProcedureReturn PBEdit_RemoveGadgetItem(canvas_gadget, position)
EndProcedure

Procedure CountItems(*this)
  ProcedureReturn PBEdit_CountGadgetItems(canvas_gadget)
EndProcedure

Procedure Redraw(*this)
 ; ProcedureReturn PBEdit_Redraw(*this)
EndProcedure

Procedure WaitClose()
  Protected event
  Repeat
    event = WaitWindowEvent()
  Until event = #PB_Event_CloseWindow
EndProcedure


CompilerIf #PB_Compiler_IsMainFile
  Enumeration 1
    #tlb_undo
    #tlb_redo
  EndEnumeration
  
  OpenWindow(0,	0, 0, 400, 400, "TextEditor", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget );;| #PB_Window_Maximize)
  
  CreateToolBar(0, WindowID(0))
  ToolBarStandardButton(#tlb_undo, #PB_ToolBarIcon_Undo)
  ToolBarStandardButton(#tlb_redo, #PB_ToolBarIcon_Redo)
  CreateStatusBar(0, WindowID(0))
  AddStatusBarField(DesktopScaledX(200))
  AddStatusBarField(DesktopScaledX(200))
  AddStatusBarField(DesktopScaledX(500))
  AddStatusBarField(DesktopScaledX(200))
  WindowBounds(0, 100,100, #PB_Ignore, #PB_Ignore)
  
  *te._PBEdit_::TE_STRUCT = Editor(5, 5+ToolBarHeight(0), WindowWidth(0) - 10, WindowHeight(0) - (ToolBarHeight(0) + MenuHeight() + StatusBarHeight(0)) - 10)
  
  
  Define a, Text.s
  ; Define m.s=#CRLF$
  Define m.s=#LF$
  
  Text.s = "This is a long line." + m.s +
           "Who should show." + 
           m.s +
           m.s +
           m.s +
           m.s +
           "I have to write the text in the box or not." + 
           m.s +
           m.s +
           m.s +
           m.s +
           "The string must be very long." + m.s +
           "Otherwise it will not work." ;+ m.s +
  
  SetText(*te, text)
  For a = 0 To 2
    AddItem(*te, a, "Line "+Str(a))
  Next
  AddItem(*te, 7+a, "_")
  For a = 4 To 6
    AddItem(*te, a, "Line "+Str(a))
  Next
  ;SetGadgetFont(0, FontID(0))
  
  Repeat
    event = WaitWindowEvent()
    
    Select event
      Case #PB_Event_CloseWindow
        If EventWindow() = 0
          End
        EndIf
      Case #PB_Event_SizeWindow
        If *te And (EventWindow() = 0)
          _PBEdit_::Event_Resize(*te, #PB_Ignore, #PB_Ignore, WindowWidth(0) - 10, WindowHeight(0) - (ToolBarHeight(0) + MenuHeight() + StatusBarHeight(0)))
        EndIf
      Case #PB_Event_Menu
        If EventMenu() = #tlb_undo
          PBEdit_Undo(0)
        ElseIf EventMenu() = #tlb_redo
          PBEdit_Redo(0)
        EndIf
      Case #PB_Event_Gadget
        StatusBarText(0, 0, "lineNr: " + Str(PBEdit_GetCurrentLineNr(0)) +
                            "  Column: " + Str(PBEdit_GetCurrentColumnNr(0)) +
                            "  (Char: " + Str(PBEdit_GetCurrentCharNr(0)) + ")")
        
        StatusBarText(0, 1, "Selection [" + 
                            Str(PBEdit_GetFirstSelectedLineNr(0)) + ", " + 
                            Str(PBEdit_GetFirstSelectedCharNr(0)) + "] [" + 
                            Str(PBEdit_GetLastSelectedLineNr(0)) + ", " + 
                            Str(PBEdit_GetLastSelectedCharNr(0)) + "]" )
        StatusBarText(0, 2, "Cursors: " + Str(ListSize(*te\cursor())))
    EndSelect
    
    ; 	*token._PBEdit_::TE_TOKEN = _PBEdit_::Parser_TokenAtCharNr(*te, *te\currentCursor\position\textline, *te\currentCursor\position\charNr)
    ; 	If *token
    ; 		StatusBarText(0, 2, "type: " + _PBEdit_::TokenEnumName(*token\type) + " text: " + PeekS(*token\text, *token\size))
    ; 	EndIf
  ForEver
CompilerEndIf
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = ----
; EnableXP