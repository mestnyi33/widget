EnableExplicit

CompilerIf #PB_Compiler_OS = #PB_OS_Linux
  ImportC "";-gtk"
    g_object_set_data_(*Widget.GtkWidget, strData.p-utf8, *userdata) As "g_object_set_data"
    g_object_get_data_(*Widget.GtkWidget, strData.p-utf8) As "g_object_get_data"
  EndImport
CompilerEndIf


Procedure SetWindowID(Window)  
  If IsWindow(Window)
    CompilerSelect #PB_Compiler_OS
      CompilerCase #PB_OS_Linux   
        ProcedureReturn  g_object_set_data_(WindowID(Window), "PB_WindowID", Window +1)
    CompilerEndSelect  
  EndIf
EndProcedure   

Procedure SetGadgetID(Gadget)  
  If IsGadget(Gadget)
    CompilerSelect #PB_Compiler_OS
      CompilerCase #PB_OS_Linux   
        ProcedureReturn  g_object_set_data_(GadgetID(Gadget), "PB_GadgetID", Gadget +1)
    CompilerEndSelect 
  EndIf
EndProcedure 

ProcedureDLL IDWindow(WindowID) ;Returns ID Window  
  CompilerSelect #PB_Compiler_OS
    CompilerCase #PB_OS_Linux   
      ProcedureReturn  g_object_get_data_(WindowID, "PB_WindowID") -1
    CompilerEndSelect  
EndProcedure   

ProcedureDLL IDGadget(GadgetID) ;Returns ID Gadget  
  CompilerSelect #PB_Compiler_OS
    CompilerCase #PB_OS_Linux   
      ProcedureReturn  g_object_get_data_(GadgetID, "PB_GadgetID") -1
    CompilerEndSelect  
EndProcedure 

ProcedureDLL IsWindowID(WindowID) ;Returns TRUE if is WindowID
  If IsWindow(IDWindow(WindowID)) 
    ProcedureReturn #True
  EndIf
EndProcedure  

ProcedureDLL IsGadgetID(GadgetID);Returns TRUE if is GadgetID
  If IsGadget(IDGadget(GadgetID))
    ProcedureReturn #True
  EndIf  
EndProcedure  

Procedure Widget(GadgetID)
  Protected Gadget = IDGadget(GadgetID)  
  Protected *Widget.GtkWidget = GadgetID :GadgetID = *Widget\object
  If IsGadget(Gadget) 
    If (GadgetType(Gadget) = #PB_GadgetType_Text Or GadgetType(Gadget) = #PB_GadgetType_Container Or
      GadgetType(Gadget) = #PB_GadgetType_Panel Or GadgetType(Gadget) = #PB_GadgetType_ComboBox Or 
      GadgetType(Gadget) = #PB_GadgetType_ListIcon Or GadgetType(Gadget) = #PB_GadgetType_ListView Or
      GadgetType(Gadget) = #PB_GadgetType_ScrollArea Or GadgetType(Gadget) = #PB_GadgetType_Editor)
    *Widget.GtkWidget = GadgetID :GadgetID = *Widget\parent
  ElseIf GadgetType(Gadget) = #PB_GadgetType_Image
    *Widget.GtkWidget = GadgetID :GadgetID = *Widget\parent
    *Widget.GtkWidget = GadgetID :GadgetID = *Widget\parent
  EndIf
  EndIf
  ProcedureReturn GadgetID
EndProcedure

Procedure WidgetWindow(GadgetID)
  Protected Gadget = IDGadget(GadgetID)  
  Protected *Widget.GtkWidget = GadgetID :GadgetID = *Widget\object
  If IsGadget(Gadget) 
    If (GadgetType(Gadget) = #PB_GadgetType_Text Or GadgetType(Gadget) = #PB_GadgetType_Container Or
        GadgetType(Gadget) = #PB_GadgetType_Panel Or GadgetType(Gadget) = #PB_GadgetType_ComboBox Or 
        GadgetType(Gadget) = #PB_GadgetType_ListIcon Or GadgetType(Gadget) = #PB_GadgetType_ListView Or
        GadgetType(Gadget) = #PB_GadgetType_Editor)
      *Widget.GtkWidget = GadgetID :GadgetID = *Widget\parent
      *Widget.GtkWidget = GadgetID :GadgetID = *Widget\parent
    ElseIf GadgetType(Gadget) = #PB_GadgetType_Image
      *Widget.GtkWidget = GadgetID :GadgetID = *Widget\parent
      *Widget.GtkWidget = GadgetID :GadgetID = *Widget\parent
      *Widget.GtkWidget = GadgetID :GadgetID = *Widget\parent
    Else
      *Widget.GtkWidget = GadgetID :GadgetID = *Widget\parent
    EndIf
  EndIf
  ProcedureReturn GadgetID
EndProcedure

Procedure WidgetParent(GadgetID)
  Protected Gadget = IDGadget(GadgetID)  
  Protected *Widget.GtkWidget = GadgetID :GadgetID = *Widget\object
  If IsGadget(Gadget) 
    If (GadgetType(Gadget) = #PB_GadgetType_Container Or
        GadgetType(Gadget) = #PB_GadgetType_Panel Or
        GadgetType(Gadget) = #PB_GadgetType_ComboBox )
      ProcedureReturn GadgetID
    ElseIf GadgetType(Gadget) = #PB_GadgetType_ScrollArea
      ;GadgetID = Widget(GadgetID)
      ;GadgetID = WidgetWindow(GadgetID)
      *Widget.GtkWidget = GadgetID :GadgetID = *Widget\parent
      *Widget.GtkWidget = GadgetID :GadgetID = *Widget\window
       *Widget.GtkWidget = GadgetID :GadgetID = *Widget\parent
;       *Widget.GtkWidget = GadgetID :GadgetID = *Widget\object
;       *Widget.GtkWidget = GadgetID :GadgetID = *Widget\object
;       *Widget.GtkWidget = GadgetID :GadgetID = *Widget\object
      ProcedureReturn GadgetID
    Else
     ProcedureReturn WidgetWindow(GadgetID)
    EndIf
  EndIf
 EndProcedure

 ProcedureDLL SetGadgetParent(Gadget,ParentID) ;Set Parent
   CompilerIf #PB_Compiler_OS = #PB_OS_Linux
     If IsGadget(Gadget)
       Protected x,y 
       x = GadgetX(Gadget)
       y = GadgetY(Gadget)
       Protected ChildID = Widget(GadgetID(Gadget))
     EndIf  
     
     If IsWindowID(ParentID)
       Protected *Window.GTKWindow
       Protected *Widget.GtkWidget
       Protected *Fixed.GtkFixed
       Protected *Box.GtkBox
       
       *Window.GTKWindow = ParentID
       ParentID = *Window\bin\child
       
       ; ;            *Widget.GtkWidget = ParentID 
       ; ;            ParentID = *Widget\object
       
       ;             *Fixed.GtkFixed = ParentID
       ;             ParentID = *Fixed\children
       
       ;            *Box.GtkBox = ParentID
       ;            ParentID = *Box\children
       
     ElseIf IsGadgetID(ParentID)
       ParentID = WidgetParent(ParentID)
     
     EndIf  
     gtk_widget_reparent_(ChildID, ParentID) 
     ResizeGadget(Gadget, x,y,#PB_Ignore,#PB_Ignore)
   CompilerEndIf
 EndProcedure
 

  CompilerIf #PB_Compiler_IsMainFile
  Define flags = #PB_Window_Invisible | #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_MaximizeGadget | #PB_Window_ScreenCentered 
   OpenWindow(10, 0, 0, 600, 400, "Main Form", flags ) :SetWindowID(10)
   ButtonGadget(10,1,1,10,10,"") :HideGadget(10,1) :SetGadgetID(10)
   ContainerGadget(1,10,100,550,160,#PB_Container_Flat)  :CloseGadgetList() :SetGadgetID(1)
    
    ButtonGadget(111,100,320,150,40,"move") 
    ButtonGadget(112,250,320,150,40,"back") 
    
  flags = #PB_Window_Invisible | #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget| #PB_Window_SizeGadget 
  OpenWindow(1, 10, 20, 330, 300, "Child Form", flags, WindowID(10)) :SetWindowID(1)
   ButtonGadget(101,1,1,10,10,"") :HideGadget(101,1) :SetGadgetID(101)
   ButtonGadget(20,30,20,250,30,"Child Form") :SetGadgetID(20)
    
    ButtonGadget(21,30,60,250,30,"Child Form") :SetGadgetID(21)
    
    HideWindow(10,0)
    HideWindow(1,0)
  
  Repeat
   Define Event=WaitWindowEvent()
    If Event=#PB_Event_Gadget 
      If EventGadget()=111
     ;SetGadgetParent(20, GadgetID(1)) ; move to container 
     
     ;move to window 
     SetGadgetParent(20, GadgetID(10)) ;work
     ;SetGadgetParent(20, WindowID(10)) ;no work
     
   ElseIf EventGadget()=112
     SetGadgetParent(20, GadgetID(101))
     
   EndIf 
    EndIf  
  Until Event=#PB_Event_CloseWindow
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (Linux - x64)
; CursorPosition = 3
; Folding = -----
; EnableXP