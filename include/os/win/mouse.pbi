CompilerIf #PB_Compiler_IsMainFile 
   XIncludeFile "id.pbi"
   XIncludeFile "parent.pbi"
CompilerEndIf

DeclareModule mouse
  Macro GadgetMouseX( _canvas_, _mode_ = #PB_Gadget_ScreenCoordinate )
     ;GetGadgetAttribute( _canvas_, #PB_Canvas_MouseX )
     ;WindowMouseX( ID::Window(ID::GetWindowID(GadgetID(_canvas_))) ) - GadgetX( _canvas_, #PB_Gadget_WindowCoordinate )
     DesktopMouseX( ) - DesktopScaledX(GadgetX( _canvas_, _mode_ ))
  EndMacro
  Macro GadgetMouseY( _canvas_, _mode_ = #PB_Gadget_ScreenCoordinate )
     ;GetGadgetAttribute( _canvas_, #PB_Canvas_MouseY )
     ;WindowMouseY(  ID::Window(ID::GetWindowID(GadgetID(_canvas_)))  ) - GadgetY( _canvas_, #PB_Gadget_WindowCoordinate )
     DesktopMouseY( ) - DesktopScaledY(GadgetY( _canvas_, _mode_ ))
  EndMacro
  
  Declare.i Window( )
   Declare.i Gadget( WindowID )
   Declare.i Handle( WindowID )
   Declare.i Buttons( )
EndDeclareModule

Module mouse
   Procedure.s ClassName( handle.i )
      Protected Class$ = Space( 16 )
      GetClassName_( handle, @Class$, Len( Class$ ) )
      ProcedureReturn Class$
   EndProcedure
   
   Procedure Window( )
      Protected Cursorpos.q, handle
      GetCursorPos_( @Cursorpos )
      handle = WindowFromPoint_( Cursorpos )
      ProcedureReturn GetAncestor_( handle, #GA_ROOT )
   EndProcedure
   
   Procedure Gadget1( WindowID )
      Protected Cursorpos.q, handle, GadgetID
      GetCursorPos_( @Cursorpos )
      
      If WindowID
         GadgetID = WindowFromPoint_( Cursorpos )
         
         If IsGadget( ID::Gadget( GadgetID ) )
            handle = GadgetID
         Else
            ScreenToClient_( WindowID, @Cursorpos ) 
            handle = ChildWindowFromPoint_( WindowID, Cursorpos )
            
            If handle = GadgetID 
               If handle = WindowID
                  ; in the window
                  ProcedureReturn WindowID
               Else
                  ; spin-gadget spin-buttons on window
                  If ClassName( handle ) = "msctls_updown32"
                     handle = GetWindow_( GadgetID, #GW_HWNDNEXT )
                  EndIf
               EndIf
            Else
               Debug ClassName( handle )
               If ClassName( handle ) = "PureSplitter"
                  handle = GetWindow_( GadgetID, #GW_HWNDNEXT )
               EndIf
               
               ; MDIGadget childrens
               If ClassName( handle ) = "MDIClient"
                  handle = FindWindowEx_( handle, 0, 0, 0 ) ; 
               EndIf
            EndIf
         EndIf
         
         ProcedureReturn handle
      Else
         ProcedureReturn 0
      EndIf
   EndProcedure
   
   Procedure Gadget( WindowID )
      ;ProcedureReturn Gadget1( WindowID )
      
      Protected Cursorpos.q, handle, GadgetID
      GetCursorPos_( @Cursorpos )
      
      If WindowID
         GadgetID = WindowFromPoint_( Cursorpos )
         
         ScreenToClient_( GadgetID, @Cursorpos ) 
         handle = ChildWindowFromPoint_( GadgetID, Cursorpos )
         
         If Not IsGadget( ID::Gadget( handle ) )
            If IsGadget( ID::Gadget( GadgetID ) )
               handle = GadgetID
            ElseIf ClassName( GadgetID ) = "Internet Explor"
               handle = GetParent_(GetParent_(GetParent_(GadgetID)))
            ElseIf ClassName( GadgetID ) = "msctls_updown32"
               handle = GetWindow_( GadgetID, #GW_HWNDPREV )
               ;           If ClassName( handle ) <> "Edit"
               ;             Debug ClassName( handle )
               ;           EndIf
            Else
               If ClassName( GadgetID ) = "MDI_ChildClass"
                  handle = GadgetID
               Else
                  handle = GetParent_(handle)
               EndIf
            EndIf
            ; panel item scroll buttons 
            If ClassName( handle ) = "Static"
               handle = GetParent_(handle)
            EndIf
            If Not handle
               handle = WindowID
            EndIf
         EndIf
         
         ProcedureReturn handle
      Else
         ProcedureReturn 0
      EndIf
   EndProcedure
   
   Procedure Handle( WindowID )
      Protected Cursorpos.q, handle, GadgetID
      GetCursorPos_( @Cursorpos )
      ;
      If WindowID
         GadgetID = WindowFromPoint_( Cursorpos )
         ;
         ScreenToClient_( GadgetID, @Cursorpos ) 
         handle = ChildWindowFromPoint_( GadgetID, Cursorpos )
         ;
         If handle
            ProcedureReturn handle
         Else
            ProcedureReturn GadgetID
         EndIf
      Else
         ProcedureReturn 0
      EndIf
   EndProcedure
     
   Procedure Buttons( )
      ; Debug #PB_MouseButton_Left   ; 1
      ; Debug #PB_MouseButton_Right  ; 2
      ; Debug #PB_MouseButton_Middle ; 3
      ;      
      ProcedureReturn GetAsyncKeyState_(#VK_LBUTTON) >> 15 & 1 + 
                      GetAsyncKeyState_(#VK_RBUTTON) >> 15 & 2 + 
                      GetAsyncKeyState_(#VK_MBUTTON) >> 15 & 3 
   EndProcedure
EndModule

;-\\ example
CompilerIf #PB_Compiler_IsMainFile 
   XIncludeFile "ClipGadgets.pbi"
   EnableExplicit
   UsePNGImageDecoder( )
   
   If Not LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/Background.bmp")
      End
   EndIf
   
   If Not LoadImage(1, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png")
      End
   EndIf
   
   Global X,Y,i
   
   Procedure scrolled()
      
   EndProcedure
   
   
   If OpenWindow(10, 0, 0, 995, 605, "", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      SetWindowColor(ID::Window(UseGadgetList(0)), $83BFEC)
      
      ; test container
      ; ContainerGadget(315, 0, 0, 995, 605)
      
      ButtonGadget(#PB_GadgetType_Button, 5, 5, 160,95, "Multiline Button_"+Str(#PB_GadgetType_Button)+" (longer text gets automatically multiline)", #PB_Button_MultiLine ) 
      StringGadget(#PB_GadgetType_String, 5, 105, 160,95, "String_"+Str(#PB_GadgetType_String)+" set"+#LF$+"multi"+#LF$+"line"+#LF$+"text")                                 
      TextGadget(#PB_GadgetType_Text, 5, 205, 160,95, "Text_"+Str(#PB_GadgetType_Text)+#LF$+"set"+#LF$+"multi"+#LF$+"line"+#LF$+"text", #PB_Text_Border)        
      CheckBoxGadget(#PB_GadgetType_CheckBox, 5, 305, 160,95, "CheckBox_"+Str(#PB_GadgetType_CheckBox), #PB_CheckBox_ThreeState) : SetGadgetState(#PB_GadgetType_CheckBox, #PB_Checkbox_Inbetween)
      OptionGadget(#PB_GadgetType_Option, 5, 405, 160,95, "Option_"+Str(#PB_GadgetType_Option) ) : SetGadgetState(#PB_GadgetType_Option, 1)                                                       
      ListViewGadget(#PB_GadgetType_ListView, 5, 505, 160,95) : AddGadgetItem(#PB_GadgetType_ListView, -1, "ListView_"+Str(#PB_GadgetType_ListView)) : For i=1 To 5 : AddGadgetItem(#PB_GadgetType_ListView, i, "item_"+Str(i)) : Next
      FrameGadget(#PB_GadgetType_Frame, 170, 5, 160,95, "Frame_"+Str(#PB_GadgetType_Frame) )
      ComboBoxGadget(#PB_GadgetType_ComboBox, 170, 105, 160,95) : AddGadgetItem(#PB_GadgetType_ComboBox, -1, "ComboBox_"+Str(#PB_GadgetType_ComboBox)) : For i=1 To 5 : AddGadgetItem(#PB_GadgetType_ComboBox, i, "item_"+Str(i)) : Next : SetGadgetState(#PB_GadgetType_ComboBox, 0) 
      ImageGadget(#PB_GadgetType_Image, 170, 205, 160,95, 0, #PB_Image_Border ) 
      HyperLinkGadget(#PB_GadgetType_HyperLink, 170, 305, 160,95,"HyperLink_"+Str(#PB_GadgetType_HyperLink), $00FF00, #PB_HyperLink_Underline ) 
      ContainerGadget(#PB_GadgetType_Container, 170, 405, 160,95, #PB_Container_Flat )
      OptionGadget(101, 10, 10, 110,20, "Container_"+Str(#PB_GadgetType_Container) )  : SetGadgetState(101, 1)  
      OptionGadget(102, 10, 40, 110,20, "Option_widget");, #pb_flag_flat)  
      CloseGadgetList()
      ListIconGadget(#PB_GadgetType_ListIcon,170, 505, 160,95,"ListIcon_"+Str(#PB_GadgetType_ListIcon),120 )                           
      
      IPAddressGadget(#PB_GadgetType_IPAddress, 335, 5, 160,95 ) : SetGadgetState(#PB_GadgetType_IPAddress, MakeIPAddress(1, 2, 3, 4))    
      ProgressBarGadget(#PB_GadgetType_ProgressBar, 335, 105, 160,95,0,100) : SetGadgetState(#PB_GadgetType_ProgressBar, 50)
      ScrollBarGadget(#PB_GadgetType_ScrollBar, 335, 205, 160,95,0,100,0) : SetGadgetState(#PB_GadgetType_ScrollBar, 40)
      ScrollAreaGadget(#PB_GadgetType_ScrollArea, 335, 305, 160,95,180,90,1, #PB_ScrollArea_Flat ) :  ButtonGadget(201, 0, 0, 150,20, "ScrollArea_"+Str(#PB_GadgetType_ScrollArea) ) :  ButtonGadget(202, 180-150, 90-20, 150,20, "Button_"+Str(202) ) : CloseGadgetList()
      TrackBarGadget(#PB_GadgetType_TrackBar, 335, 405, 160,95,0,21, #PB_TrackBar_Ticks) : SetGadgetState(#PB_GadgetType_TrackBar, 11)
      WebGadget(#PB_GadgetType_Web, 335, 505, 160,95,"https://www.purebasic.com" )
      
      ButtonImageGadget(#PB_GadgetType_ButtonImage, 500, 5, 160,95, ImageID(0), 1)
      CalendarGadget(#PB_GadgetType_Calendar, 500, 105, 160,95 )
      DateGadget(#PB_GadgetType_Date, 500, 205, 160,95 )
      EditorGadget(#PB_GadgetType_Editor, 500, 305, 160,95 ) : AddGadgetItem(#PB_GadgetType_Editor, -1, "set"+#LF$+"editor"+#LF$+"_"+Str(#PB_GadgetType_Editor) +#LF$+"add"+#LF$+"multi"+#LF$+"line"+#LF$+"text")  
      ExplorerListGadget(#PB_GadgetType_ExplorerList, 500, 405, 160,95,"" )
      ExplorerTreeGadget(#PB_GadgetType_ExplorerTree, 500, 505, 160,95,"" )
      
      ExplorerComboGadget(#PB_GadgetType_ExplorerCombo, 665, 5, 160,95,"" )
      SpinGadget(#PB_GadgetType_Spin, 665, 105, 160,95,20,100)
      
      TreeGadget(#PB_GadgetType_Tree, 665, 205, 160, 95 ) 
      AddGadgetItem(#PB_GadgetType_Tree, -1, "Tree_"+Str(#PB_GadgetType_Tree)) 
      For i=1 To 5 : AddGadgetItem(#PB_GadgetType_Tree, i, "item_"+Str(i)) : Next
      ButtonGadget(-1,665+10,205+5,50,35, "444444") 
      
      PanelGadget(#PB_GadgetType_Panel,665, 305, 160,95) 
      AddGadgetItem(#PB_GadgetType_Panel, -1, "Panel_"+Str(#PB_GadgetType_Panel)) 
      ButtonGadget(255, 0, 0, 90,20, "Button_255" ) 
      For i=1 To 5 : AddGadgetItem(#PB_GadgetType_Panel, i, "item_"+Str(i)) : ButtonGadget(-1,10,5,50,35, "butt_"+Str(i)) : Next 
      CloseGadgetList()
      
      OpenGadgetList(#PB_GadgetType_Panel, 1)
      ContainerGadget(-1,10,5,150,55, #PB_Container_Flat) 
      ContainerGadget(-1,10,5,150,55, #PB_Container_Flat) 
      ButtonGadget(-1,10,5,50,35, "butt_1") 
      CloseGadgetList()
      CloseGadgetList()
      CloseGadgetList()
      SetGadgetState( #PB_GadgetType_Panel, 4)
      
      ; bug spin in splitter
      SpinGadget(301, 0, 0, 100,20,0,10)
      SpinGadget(302, 0, 0, 100,20,0,10) 
      Define Gadget301 = GetWindow_( GadgetID( 301 ), #GW_HWNDNEXT )
      Define Gadget302 = GetWindow_( GadgetID( 302 ), #GW_HWNDNEXT )
      SplitterGadget(#PB_GadgetType_Splitter, 665, 405, 160, 95, 301, 302)
      SetParent_( Gadget301, GadgetID(#PB_GadgetType_Splitter) )
      SetWindowPos_(Gadget301, GadgetID(301), 0, 0, 0, 0, #SWP_NOSIZE | #SWP_NOMOVE)
      SetParent_( Gadget302, GadgetID(#PB_GadgetType_Splitter) )
      SetWindowPos_(Gadget302, GadgetID(302), 0, 0, 0, 0, #SWP_NOSIZE | #SWP_NOMOVE)
      
      ;
      MDIGadget( #PB_GadgetType_MDI,665, 505, 160,95,0,0 ) : AddGadgetItem(#PB_GadgetType_MDI,-1,"form_1") :UseGadgetList(WindowID(10))
      
      CompilerIf #PB_Compiler_Version < 600
         InitScintilla( ) 
      CompilerEndIf
      ScintillaGadget(#PB_GadgetType_Scintilla, 830, 5, 160,95,0 )
      ShortcutGadget(#PB_GadgetType_Shortcut, 830, 105, 160,95 ,-1)
      CanvasGadget(#PB_GadgetType_Canvas, 830, 205, 160,95 )
      CanvasGadget(#PB_GadgetType_Canvas+1, 830, 305, 160,95, #PB_Canvas_Container ):CloseGadgetList()
      
      If IsGadget(315)
         CloseGadgetList()
      EndIf
      ClipGadgets(WindowID(10))
      
      Define eventID,  WindowID , gadgetID, gadget
      Repeat
         eventID = WaitWindowEvent( )
         WindowID = mouse::Window( )
         gadgetID = mouse::Gadget( WindowID )
         
         If gadgetID
            gadget = ID::Gadget( gadgetID )
            
            If gadget =- 1
               If IsWindow(ID::Window(gadgetID))
                  Debug "Form - ("+ ID::Window( gadgetID ) +") "+ gadgetID +" "+ ID::ClassName( gadgetID )
               Else
                  Debug "window - ("+ ID::Window( WindowID ) +") "+ WindowID +" "+ ID::ClassName( WindowID )
               EndIf
            Else
               Debug "gadget - ("+ gadget +") "+ gadgetID +" "+ ID::ClassName( mouse::Handle( WindowID ) )
               
               ;           If StartDrawing( WindowOutput( EventWindow() ))
               ; ;             DrawingMode( #PB_2DDrawing_Default )
               ; ;             Box( 0,0,OutputWidth(),OutputHeight(),$ff0000) 
               ;             DrawingMode( #PB_2DDrawing_Outlined )
               ;             Box( GadgetX(gadget),GadgetY(gadget),GadgetWidth(gadget),GadgetHeight(gadget),$ff0000) 
               ;             StopDrawing()
               ;           EndIf
            EndIf
         EndIf
         
         Select eventID 
            Case #PB_Event_Gadget
               If EventGadget( ) = #PB_GadgetType_ScrollBar
                  SetGadgetState( #PB_GadgetType_ProgressBar, GetGadgetState( #PB_GadgetType_ScrollBar ) )
               EndIf
         EndSelect
      Until eventID = #PB_Event_CloseWindow
   EndIf   
CompilerEndIf
; IDE Options = PureBasic 6.00 LTS (MacOS X - x64)
; CursorPosition = 6
; Folding = --4----
; EnableXP