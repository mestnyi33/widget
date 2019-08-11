IncludePath "/Users/as/Documents/GitHub/Widget";/exemples/"
XIncludeFile "widgets.pbi"

Global Window_0

Global Combo_0, btnMag1, ListView_0, btnMag2, btnShort, btnLong,txtShort

Enumeration FormFont
  #Font_Window_0_0
EndEnumeration

LoadFont(#Font_Window_0_0,"Sans", 16)




Define Event.i,iLoop.i

UseModule widget



  Window_0 = OpenWindow(#PB_Any, 0, 0, 600, 400, "", #PB_Window_SystemMenu)
  open(Window_0, 0, 0, 600, 400)
  
  btnMag2 = Button(330, 10, 110, 25, "Magic 2")
  btnMag1 = Button(210, 10, 110, 20, "Magic 1")
  
  Combo_0 = ComboBox(10, 10, 160, 30)

  ListView_0 = ListView(10, 60, 160, 150)
  
  btnShort = Button(10, 230, 90, 30, "Short")
  btnLong = Button(130, 230, 90, 30, "Long")
  btnFont = Button(250, 230, 90, 30, "Font")
  txtShort = Text(210, 140, 120, 20, "Short")
  txtImportant = Text(270, 140, 60, 20, "Important")
  
   
  
  
  
  Repeat
    
    Event = WaitWindowEvent()
  
  

  Select event
    Case #PB_Event_CloseWindow
      End

    Case #PB_Event_Menu
      Select EventMenu()
      EndSelect

    Case #PB_Event_Gadget
      Select EventWidget()
          
        Case btnFont
          
          SetFont(btnMag1, FontID(#Font_Window_0_0))
          SetFont(txtShort, FontID(#Font_Window_0_0))
          
        Case btnMag1
          
          Debug "Magic 1"
          
          
        Case btnMag2
          
          Debug "Magic 2"
          
        Case btnShort
          
          ClearItems(Combo_0)
          ClearItems(ListView_0)
          
          For iLoop = 0 To 20
          
          AddItem(Combo_0,-1,"Item " + Str(iLoop))
          AddItem(ListView_0,-1,"Item " + Str(iLoop))
        Next
        
        SetText(btnMag1,"Magic 1")
        SetText(txtShort,"Short")
        
      Case btnLong  
        
               ClearItems(Combo_0)
          ClearItems(ListView_0)   
        
        
        For iLoop = 0 To 20
          
          AddItem(Combo_0,-1,"Item " + Str(iLoop) + " A much Longer String To Check It Out. The Quick Brown Fox Jumps Over The Lazy Dog.")
          AddItem(ListView_0,-1,"Item " + Str(iLoop) + " A much Longer String To Check It Out")
        Next
        
        SetText(btnMag1,"Just Checking it out")
        SetText(txtShort,"Checking How text Gadgets React")
          
      EndSelect
  EndSelect
  
  ForEver
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = -
; EnableXP