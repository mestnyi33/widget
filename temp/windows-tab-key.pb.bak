;-Window Constants 
Enumeration 1 
  #Window_Form1 
EndEnumeration 
;-Gadget Constants 
Enumeration 1 
  #Gadget_Form1_Text0 
  #Gadget_Form1_Editor1  
  #Gadget_Form1_Editor2  
  #Gadget_Form1_Option3 
  #Gadget_Form1_Option4  
  #Gadget_Form1_String5  
  #Gadget_Form1_String6  
  #Gadget_Form1_String7  
  
  #Gadget_Form1_Button8  
EndEnumeration 

Procedure WinCallback(hwnd, msg, wParam, lParam) 
  result = #PB_ProcessPureBasicEvents 
  Select msg 
    Case #WM_NOTIFY 
      *pnmhdr.NMHDR = lParam 
      
      Select *pnmhdr\code
        Case #EN_MSGFILTER
          *pMSGFILTER.MSGFILTER = lParam 
          
          If *pMSGFILTER\wParam = #VK_TAB And *pMSGFILTER\msg <> #WM_KEYUP 
            Select *pnmhdr\hwndFrom
              Case GadgetID(#Gadget_Form1_Editor1)  
                SetActiveGadget(#Gadget_Form1_Editor2)
                ; --> Return non-zero to ignore the Tab key 
                result = 1 
              Case GadgetID(#Gadget_Form1_Editor2)  
                SetActiveGadget(#Gadget_Form1_Option3)
                ; --> Return non-zero to ignore the Tab key 
                result = 1 
            EndSelect
          EndIf 
      EndSelect 
  EndSelect 
  ProcedureReturn result 
EndProcedure 

Procedure.l Window_Form1() 
  If OpenWindow(#Window_Form1,176,92,400,300,"How to use TAB key with editor",#PB_Window_SystemMenu|#PB_Window_ScreenCentered|#PB_Window_Invisible) 
    If CreateGadgetList(WindowID(#Window_Form1)) 
      TextGadget(#Gadget_Form1_Text0,0,7,395,15,"Move the cursor wit TAB key between gadgets",#PB_Text_Center) 
      
      EditorGadget(#Gadget_Form1_Editor1,50,25,300,75) 
      EditorGadget(#Gadget_Form1_Editor2,50,110,300,60) 
      
      ;...Tell the EditorGadgets we want ot filter keyboard messages 
      ;...We catch the events in the #WM_NOTIFY msg in our CallBack procedure 
      SendMessage_(GadgetID(#Gadget_Form1_Editor1), #EM_SETEVENTMASK, 0, #ENM_KEYEVENTS) 
      SendMessage_(GadgetID(#Gadget_Form1_Editor2), #EM_SETEVENTMASK, 0, #ENM_KEYEVENTS) 
      
      OptionGadget(#Gadget_Form1_Option3,55,180,80,15,"Option9") 
      OptionGadget(#Gadget_Form1_Option4,270,180,80,15,"Option10") 
      
      StringGadget(#Gadget_Form1_String5,55,210,80,25,"") 
      StringGadget(#Gadget_Form1_String6,160,210,80,25,"") 
      StringGadget(#Gadget_Form1_String7,270,210,80,25,"") 
      
      ButtonGadget(#Gadget_Form1_Button8,175,265,60,25,"EXIT") 
      HideWindow(#Window_Form1,0) 
      
      ;...Window callback is where we catch tab key events from our EditorGadget
      SetWindowCallback(@WinCallback())
      ProcedureReturn WindowID(#Window_Form1) 
    EndIf 
  EndIf 
EndProcedure 


;-Main Loop 
If Window_Form1() 
  
  quitForm1=0 
  Repeat 
    EventID  =WaitWindowEvent() 
    MenuID   =EventMenu() 
    GadgetID =EventGadget() 
    WindowID =EventWindow() 
    
    Select EventID 
      Case #PB_Event_CloseWindow 
        If WindowID=#Window_Form1 
          quitForm1=1 
        EndIf 
        
        
      Case #PB_Event_Gadget 
        Select GadgetID 
          Case #Gadget_Form1_Editor1  
          Case #Gadget_Form1_Editor2 
          Case #Gadget_Form1_Option3  
          Case #Gadget_Form1_Option4 
          Case #Gadget_Form1_String5  
          Case #Gadget_Form1_String6  
          Case #Gadget_Form1_String7  
          Case #Gadget_Form1_Button8  
        EndSelect 
        
    EndSelect 
  Until quitForm1 
  CloseWindow(#Window_Form1) 
EndIf 
End 

; IDE Options = PureBasic 5.73 LTS (Windows - x64)
; Folding = ---
; EnableXP