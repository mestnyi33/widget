; ******************************************************************** 
; Program:           AutoComplete List
; Description:       Add an AutoComplete list to a String gadget 

; Author:            Thyphoon
; Date:              January, 2019
; License:           Free, unrestricted, credit 
;                    appreciated but not required.
; Note:              Please share improvement !
; ******************************************************************** 

EnableExplicit

DeclareModule AutoComplete
  Declare AddAutocompleteWindow(Window.i,Gadget.i,*CallBack,FirstEventKey.l=5000)
  Declare CheckEvent(Event.i)
EndDeclareModule  

Module AutoComplete
  
  Prototype.s CallBack(String.s)
  
  Structure ac
    Window.i                  ;Original Window
    Gadget.i                  ;Original Gadget
    FirstEventKey.l           ;First Eventkey=Up +1=Down +2=Enter +3=Escape
    CallBack.CallBack         ;CallBack who return choice
  EndStructure
  
  Structure params
    acWindow.i                ;Autocomplete window
    acGadget.i                ;AutoComplete GadgetList
    CurrentName.s             ;CurrentName at last open autocomplete windows
    Map AutoCompleteGadget.ac()
    FirstEventKey.i
  EndStructure
  
  Global params.params
  
  
  Procedure AddAutocompleteWindow(Window.i,Gadget.i,*CallBack,FirstEventKey.l=5000)
    Name.s=Str(Window)+"-"+Str(Gadget)
    params\AutoCompleteGadget(Name)\CallBack=*CallBack
    params\AutoCompleteGadget(Name)\Gadget=Gadget
    params\AutoCompleteGadget(Name)\Window=Window
    params\AutoCompleteGadget(Name)\FirstEventKey=FirstEventKey
    AddKeyboardShortcut(Window, #PB_Shortcut_Up, FirstEventKey)
    AddKeyboardShortcut(Window, #PB_Shortcut_Down, FirstEventKey+1)
    AddKeyboardShortcut(Window, #PB_Shortcut_Return, FirstEventKey+2)
    AddKeyboardShortcut(Window, #PB_Shortcut_Escape, FirstEventKey+3)
  EndProcedure
  
  Procedure RefreshAutocompleteWindow(Name.s)
    Gadget.i=params\AutoCompleteGadget(Name)\Gadget
    Windows.i=params\AutoCompleteGadget(Name)\Window
    Debug Gadget
    X.l=WindowX(Windows,#PB_Window_InnerCoordinate)+GadgetX(Gadget)
    Y.l=WindowY(Windows,#PB_Window_InnerCoordinate)+GadgetY(Gadget)+GadgetHeight(Gadget)
    W.l=GadgetWidth(Gadget)
    H.l=150
    ResizeWindow(params\acWindow,X,Y,W,H)
    ResizeGadget(params\acGadget,0,0,W,H)
    HideWindow(params\acWindow, #False,#PB_Window_NoActivate)
    StickyWindow(params\acWindow,#True)
  EndProcedure
  
  Procedure UpdateAutocompleteList(Name.s)
    ClearGadgetItems(params\acGadget)
    If params\AutoCompleteGadget(Name)\CallBack<>0
      BackString.s=params\AutoCompleteGadget(Name)\CallBack(GetGadgetText(params\AutoCompleteGadget(Name)\Gadget))

      For n=1 To CountString(BackString,Chr(10))+1
        line.s=StringField(BackString,n,Chr(10))
        If LCase(Left(line,Len(GetGadgetText(params\AutoCompleteGadget(Name)\Gadget))))=LCase(GetGadgetText(params\AutoCompleteGadget(Name)\Gadget))
          AddGadgetItem(params\acGadget,-1,line)
        EndIf 
      Next
      ;Hide Autocomplete Window if no Choice
      If CountGadgetItems(params\acGadget)=0
        HideWindow(params\acWindow,#True)
      Else
        HideWindow(params\acWindow,#False,#PB_Window_NoActivate)
      EndIf 
    Else
      Debug "Error with callback"
    EndIf
  EndProcedure
  
  Procedure OpenAutocompleteWindow(Name.s)
    If params\acGadget>0 And IsGadget(params\acGadget):FreeGadget(params\acGadget):EndIf
    If params\acWindow>0 And IsWindow(params\acWindow):CloseWindow(params\acGadget):EndIf
    params\acWindow=OpenWindow(#PB_Any,0,0,50,50,"AutoComplete",#PB_Window_BorderLess|#PB_Window_NoActivate,WindowID(Window));
    If params\acWindow
      params\CurrentName=Name
      SetWindowData(params\acWindow,params\AutoCompleteGadget(Name)\Gadget)
      params\acGadget=ListViewGadget(#PB_Any, 0, 0, 50,50)
    EndIf
    RefreshAutocompleteWindow(Name)
    UpdateAutocompleteList(Name)
  EndProcedure
  
  Procedure CloseAutocompleteWindow(Name.s)
      Gadget.i=params\AutoCompleteGadget(Name)\Gadget
      Windows.i=params\AutoCompleteGadget(Name)\Window
      If params\acGadget>0 And IsGadget(params\acGadget):FreeGadget(params\acGadget):EndIf
      If params\acWindow>0 And IsWindow(params\acWindow):CloseWindow(params\acWindow):EndIf
  EndProcedure
  
  Procedure CheckEvent(Event.i)
    Static bbclick.b
    ;-Orignal Gadget Event
    Protected Name.s=Str(EventWindow())+"-"+Str(EventGadget())   
    If FindMapElement(params\AutoCompleteGadget(),Name)
      Select Event
        Case  #PB_Event_Gadget
          Select EventGadget()
              ; Main gadget Event  
            Case params\AutoCompleteGadget()\Gadget
              Select EventType()
                Case #PB_EventType_Focus
                  If params\acWindow=0 Or IsWindow(params\acWindow)=#False
                    If bbclick=#False
                      OpenAutocompleteWindow(Name)
                    Else
                      bbclick=#True
                    EndIf 
                  EndIf 
                Case #PB_EventType_LostFocus
                  If GetActiveGadget()<>params\acGadget
                    CloseAutocompleteWindow(Name)
                    bbclick=#False
                  EndIf  
                Case #PB_EventType_Change
                  If bbclick=#False 
                    If IsWindow(params\acWindow)
                      UpdateAutocompleteList(Name)
                    Else
                      Debug "pas de windows"
                    EndIf
                  Else
                    OpenAutocompleteWindow(Name)
                    bbclick=#False
                  EndIf 
              EndSelect 

          EndSelect 
     EndSelect
    EndIf
    
    Select Event
      ;If Original Window Move  
      Case #PB_Event_MoveWindow,#PB_Event_SizeWindow 
        If EventWindow()=params\AutoCompleteGadget()\Window And params\acWindow>0 And IsWindow(params\acWindow)
          RefreshAutocompleteWindow(params\CurrentName)
        EndIf
      ;if Keyword  
      Case #PB_Event_Menu
        Select EventMenu()
          Case params\AutoCompleteGadget(params\CurrentName)\FirstEventKey;UP
            SetGadgetState(params\acGadget,GetGadgetState(params\acGadget)-1)
          Case params\AutoCompleteGadget(params\CurrentName)\FirstEventKey+1;Down
            SetGadgetState(params\acGadget,GetGadgetState(params\acGadget)+1)
          Case params\AutoCompleteGadget(params\CurrentName)\FirstEventKey+2;Enter
            SetGadgetText(params\AutoCompleteGadget()\Gadget,GetGadgetItemText(params\acGadget,GetGadgetState(params\acGadget)))
          Case params\AutoCompleteGadget(params\CurrentName)\FirstEventKey+3;
            CloseAutocompleteWindow(params\CurrentName)
        EndSelect
      Case  #PB_Event_Gadget
        If EventGadget()=params\acGadget
          If EventType()=#PB_EventType_LeftDoubleClick
            SetGadgetText(params\AutoCompleteGadget(params\CurrentName)\Gadget,GetGadgetItemText(params\acGadget,GetGadgetState(params\acGadget)))
            CloseAutocompleteWindow(params\CurrentName)
            bbclick=#True
          EndIf
        EndIf 
    EndSelect  
    
    
    
  EndProcedure  
  
  
EndModule

;- MAIN TEST

CompilerIf #PB_Compiler_IsMainFile 
  
  ; Callback to return keyword list. you must use a database en filter if you want ^_^ 
  Procedure.s ToDisplayInList(String.s)
    ProcedureReturn "Amiga"+Chr(10)+"Amstrad"+Chr(10)+"Atari"+Chr(10)+"Commodore"+Chr(10)+"BeBox"+Chr(10)+"Macintosh"+Chr(10)+"Spectrum"
  EndProcedure
  
  Procedure.s ToDisplayInListB(String.s)
    ProcedureReturn "Alain"+Chr(10)+"Bernard"+Chr(10)+"Charly"+Chr(10)+"David"+Chr(10)+"Eric"+Chr(10)+"Filipe"+Chr(10)+"Horace"+Chr(10)+"Jérome"+Chr(10)+"Kevin"+Chr(10)+"Laurent"+Chr(10)+"Marc"
  EndProcedure
  
  If OpenWindow(0, 200, 200, 800, 300, "AutoComplete Teste", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    
    StringGadget(1, 10, 10, 380, 26, "")
    StringGadget(2, 410, 10, 380, 26, "")
    
    
    AutoComplete::AddAutocompleteWindow(0,1,@ToDisplayInList()) ;Just init the gadget who must support AutoComplete list
    AutoComplete::AddAutocompleteWindow(0,2,@ToDisplayInListB())
    Repeat
      Define Event.i = WaitWindowEvent()
      
      
      AutoComplete::CheckEvent(Event)
      
      Select Event
        Case #PB_Event_Gadget
      EndSelect
      
    Until Event=#PB_Event_CloseWindow
  EndIf
  End
CompilerEndIf
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = -------
; EnableXP