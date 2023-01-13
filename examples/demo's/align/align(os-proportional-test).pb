; -----------------------------------------------------------------------------
;           Name:
;    Description:
;         Author:
;           Date: 2023-01-13
;        Version:
;     PB-Version:
;             OS:
;         Credit:
;          Forum:
;     Created by: IceDesign
; -----------------------------------------------------------------------------

EnableExplicit

;- Enumerations
Enumeration Window
  #Window_0
EndEnumeration

Enumeration Gadgets
  #Btn_1
  #Btn_4
  #Btn_5
  #Btn_2
  #Btn_7
  #Btn_6
  #Btn_3
  #Btn_8
  #Btn_9
EndEnumeration

;- Declare
Declare Resize_Window_0()
Declare Open_Window_0(X = 0, Y = 0, Width = 460, Height = 200)
Global parent_align_width, parent_align_height
Global align_x = 10
Global align_y = 10
Global align_width = 120
Global align_height = 40

Procedure Resize_Window_0()
  Protected ScaleX.f, ScaleY.f, Width, Height
  
  Protected parent_width = WindowWidth(#Window_0)
  Protected parent_height = WindowHeight(#Window_0)
  
  ScaleX = parent_width / parent_align_width 
  ScaleY = parent_height / parent_align_height
  
  Width = ScaleX * align_width 
  Height = ScaleY * align_height
  ResizeGadget(#Btn_1, align_x, align_y, Width, Height)
  
  Width = ScaleX * align_width 
  Height = ScaleY * align_height
  ResizeGadget(#Btn_4, (parent_width - Width) / 2, align_y, Width, Height)
  
  Width = ScaleX * align_width 
  Height = ScaleY * align_height
  ResizeGadget(#Btn_5, parent_width - Width - align_x, align_y, Width, Height)
  
  Width = ScaleX * align_width 
  Height = ScaleY * align_height
  ResizeGadget(#Btn_2, align_x, (parent_height - Height) / 2, Width, Height)
  
  Width = ScaleX * align_width 
  Height = ScaleY * align_height
  ResizeGadget(#Btn_7, (parent_width - Width) / 2, (parent_height - Height) / 2, Width, Height)
  
  Width = ScaleX * align_width 
  Height = ScaleY * align_height
  ResizeGadget(#Btn_6, parent_width - Width - align_x, (parent_height - Height) / 2, Width, Height)
  
  Width = ScaleX * align_width 
  Height = ScaleY * align_height
  ResizeGadget(#Btn_3, align_x, parent_height - Height - align_y, Width, Height)
  
  Width = ScaleX * align_width 
  Height = ScaleY * align_height
  ResizeGadget(#Btn_8, (parent_width - Width) / 2, parent_height - Height - align_y, Width, Height)
  
  Width = ScaleX * align_width 
  Height = ScaleY * align_height
  ResizeGadget(#Btn_9, parent_width - Width - align_x, parent_height - Height - align_y, Width, Height)
EndProcedure

Procedure Open_Window_0(X = 0, Y = 0, Width = 460, Height = 200)
   parent_align_width = Width
    parent_align_height = Height
  
  If OpenWindow(#Window_0, X, Y, Width, Height, "Title", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget | #PB_Window_SizeGadget | #PB_Window_ScreenCentered)
    ButtonGadget(#Btn_1, align_x, align_y, align_width, align_height, "left&top")
    ButtonGadget(#Btn_4, 170, align_y, align_width, align_height, "top")
    ButtonGadget(#Btn_5, 330, align_y, align_width, align_height, "top&right")
    
    ButtonGadget(#Btn_2, align_x, 105, align_width, align_height, "left")
    ButtonGadget(#Btn_3, align_x, 200, align_width, align_height, "left&bottom")
    
    ButtonGadget(#Btn_7, 170, 105, align_width, align_height, "Button_7")
    ButtonGadget(#Btn_6, 330, 105, align_width, align_height, "Button_6")
    ButtonGadget(#Btn_8, 170, 200, align_width, align_height, "Button_8")
    ButtonGadget(#Btn_9, 330, 200, align_width, align_height, "Button_9")

    BindEvent(#PB_Event_SizeWindow, @Resize_Window_0(), #Window_0)
    PostEvent(#PB_Event_SizeWindow, #Window_0, 0)
  EndIf
EndProcedure

;- Main Program
Open_Window_0()

;- Event Loop
Repeat
  Select WaitWindowEvent()
    Case #PB_Event_CloseWindow
      Break

      ;-> Event Gadget
    Case #PB_Event_Gadget
      Select EventGadget()
        Case #Btn_1   ; Button_1
          MessageRequester("Information", "Button Name : #Btn_1" +#CRLF$+#CRLF$+ "Text : " + GetGadgetText(EventGadget()))
        Case #Btn_4   ; Button_4
          MessageRequester("Information", "Button Name : #Btn_4" +#CRLF$+#CRLF$+ "Text : " + GetGadgetText(EventGadget()))
        Case #Btn_5   ; Button_5
          MessageRequester("Information", "Button Name : #Btn_5" +#CRLF$+#CRLF$+ "Text : " + GetGadgetText(EventGadget()))
        Case #Btn_2   ; Button_2
          MessageRequester("Information", "Button Name : #Btn_2" +#CRLF$+#CRLF$+ "Text : " + GetGadgetText(EventGadget()))
        Case #Btn_7   ; Button_7
          MessageRequester("Information", "Button Name : #Btn_7" +#CRLF$+#CRLF$+ "Text : " + GetGadgetText(EventGadget()))
        Case #Btn_6   ; Button_6
          MessageRequester("Information", "Button Name : #Btn_6" +#CRLF$+#CRLF$+ "Text : " + GetGadgetText(EventGadget()))
        Case #Btn_3   ; Button_3
          MessageRequester("Information", "Button Name : #Btn_3" +#CRLF$+#CRLF$+ "Text : " + GetGadgetText(EventGadget()))
        Case #Btn_8   ; Button_8
          MessageRequester("Information", "Button Name : #Btn_8" +#CRLF$+#CRLF$+ "Text : " + GetGadgetText(EventGadget()))
        Case #Btn_9   ; Button_9
          MessageRequester("Information", "Button Name : #Btn_9" +#CRLF$+#CRLF$+ "Text : " + GetGadgetText(EventGadget()))
      EndSelect

  EndSelect
ForEver

; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = -
; EnableXP