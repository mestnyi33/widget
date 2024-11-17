IncludePath "../../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
   
   EnableExplicit
   UseWidgets( )
   
   Enumeration
      #window_0
      #window
   EndEnumeration
   
   Procedure Show_DEBUG( )
      Define line.s
      ;\\
      Debug "---->>"
      ForEach widgets( )
         ;Debug widgets( )\class
         line = "  "
         
         If widgets( )\BeforeWidget( )
            line + widgets( )\BeforeWidget( )\class +" <<  "    ;  +"_"+widgets( )\BeforeWidget( )\text\string
         Else
            line + "-------- <<  " 
         EndIf
         
         line + widgets( )\class ; widgets( )\text\string
         
         If widgets( )\AfterWidget( )
            line +"  >> "+ widgets( )\AfterWidget( )\class ;+"_"+widgets( )\AfterWidget( )\text\string
         Else
            line + "  >> --------" 
         EndIf
         
         Debug line
      Next
      Debug "<<----"
   EndProcedure
   
   ;-\\ ANCHORS
   Global view, size_value, pos_value, grid_value, back_color, frame_color, size_text, pos_text, grid_text
   
   OpenWindow(#window, 0, 0, 800, 600, "PanelGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
   
   
   ;\\
   Define *root1._s_WIDGET = Open(#window, 300, 10, 300 - 20, 300 - 20): *root1\class = "root1": SetTextWidget(*root1, "root1")
   ;BindWidgetEvent( *root1, @HandlerEvents( ) )
   
  
   
   
   Define *g,editable,a,count = 2;0000
   #st          = 1
   Global mx    = #st, my = #st
   
   Define time = ElapsedMilliseconds( )
   
   Global *c, *p, *panel._s_WIDGET
   Procedure do_Events( )
      Select WidgetEvent( )
         Case #__event_LeftClick
            
            Select GetTextWidget( EventWidget( ) )
               Case "hide_children"
                  Hide(*p, 1)
                  ; Disable(*c, 1)
                  
               Case "show_children"
                  Hide(*p, 0)
                  
               Case "hide_parent"
                  Hide(*c, GetState( EventWidget( ) ))
                  
            EndSelect
            
            ;         ;Case #__event_LeftUp
            ;         ClearDebugOutput( )
            ; PushListPosition( panel_children( ))
            ;         If StartEnum(*panel);Root( ))
            ;           If Not Hide(widget( )) ;And GetParent(widget( )) = *panel
            ;             Debug " class - " + widget( )\Class ;+" ("+ widget( )\item +" - parent_item)"
            ;           EndIf
            ;           StopEnum( )
            ;         EndIf
            ; PopListPosition( panel_children( ))
            
            
      EndSelect
   EndProcedure
   
   OpenList( *root1 )
   *panel = PanelWidget(20, 20, 180 + 40, 180 + 60, editable) : SetTextWidget(*panel, "1")
   AddItem( *panel, -1, "item_1" )
   
   AddItem( *panel, -1, "(hide&show)-test" )
   
   *c = PanelWidget(110, 5, 150, 155)
    AddItem(*c, -1, "0")
   
;    *p = PanelWidget(10, 5, 150, 65)
;    AddItem(*p, -1, "item-1")
; ;    ContainerWidget(10, 5, 150, 55, #PB_Container_Flat)
; ; ;    ContainerWidget(10, 5, 150, 55, #PB_Container_Flat)
   ButtonWidget(10, 5, 50, 25, "butt1")
; ; ;    CloseList( )
; ;    CloseList( )
; ; ;    AddItem(*p, -1, "item-2")
; ; ;    ContainerWidget(10, 5, 150, 55, #PB_Container_Flat)
; ; ;    ContainerWidget(10, 5, 150, 55, #PB_Container_Flat)
; ; ;    ButtonWidget(10, 5, 50, 25, "butt2")
; ; ;    CloseList( )
; ; ;    CloseList( )
; ; ;    AddItem(*c, -1, "1")
;    CloseList( )
   
;    ContainerWidget(10, 75, 150, 55, #PB_Container_Flat)
;    ContainerWidget(10, 5, 150, 55, #PB_Container_Flat)
;    ContainerWidget(10, 5, 150, 55, #PB_Container_Flat)
;    ButtonWidget(10, 5, 50, 45, "butt1")
;    CloseList( )
;    CloseList( )
;    CloseList( )
   CloseList( )
   
   Show_DEBUG( )

   WaitClose( )
   
CompilerEndIf


CompilerIf #PB_Compiler_IsMainFile = 99
   
   EnableExplicit
   UseWidgets( )
   
   Enumeration
      #window_0
      #window
   EndEnumeration
   
   Procedure Show_DEBUG( )
      Define line.s
      ;\\
      Debug "---->>"
      ForEach widgets( )
         ;Debug widgets( )\class
         line = "  "
         
         If widgets( )\BeforeWidget( )
            line + widgets( )\BeforeWidget( )\class +" <<  "    ;  +"_"+widgets( )\BeforeWidget( )\text\string
         Else
            line + "-------- <<  " 
         EndIf
         
         line + widgets( )\class ; widgets( )\text\string
         
         If widgets( )\AfterWidget( )
            line +"  >> "+ widgets( )\AfterWidget( )\class ;+"_"+widgets( )\AfterWidget( )\text\string
         Else
            line + "  >> --------" 
         EndIf
         
         Debug line
      Next
      Debug "<<----"
   EndProcedure
   
   ;-\\ ANCHORS
   Global view, size_value, pos_value, grid_value, back_color, frame_color, size_text, pos_text, grid_text
   Define i,a
   Define *w._s_WIDGET, *g._s_WIDGET
   
   Open(#window, 0, 0, 800, 600, "PanelGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
   
   ;\\
   Define *root1._s_WIDGET = root( ): *root1\class = "root1": SetTextWidget(*root1, "root1")
   ;BindWidgetEvent( *root1, @HandlerEvents( ) )
   
   
   
   Define count = 2;0000
   #st          = 1
   Global mx    = #st, my = #st
   
   Define time = ElapsedMilliseconds( )
   
   Global *c, *p, *panel._s_WIDGET
   Procedure events_containers( )
      Protected repaint
      Protected colorback = colors::*this\blue\fore,
                colorframe = colors::*this\blue\frame,
                colorback1 = $ff00ff00,
                colorframe1 = $ff0000ff
      
      Select WidgetEvent( )
         Case #__event_MouseEnter,
              #__event_MouseLeave,
              #__event_MouseMove
            
            If EventWidget( ) <> root( )
               If EventWidget( )\enter
                  If EventWidget( )\color\frame <> colorframe1
                     repaint                    = 1
                     EventWidget( )\color\frame = colorframe1
                  EndIf
                  
                  If EventWidget( )\inner_enter( )
                     If EventWidget( )\color\back <> colorback1
                        repaint                   = 1
                        EventWidget( )\color\back = colorback1
                     EndIf
                  Else
                     If EventWidget( )\color\back = colorback1
                        repaint                   = 1
                        EventWidget( )\color\back = colorback
                     EndIf
                  EndIf
               Else
                  If EventWidget( )\color\back <> colorback
                     repaint                   = 1
                     EventWidget( )\color\back = colorback
                  EndIf
                  If EventWidget( )\color\frame = colorframe1
                     repaint                    = 1
                     EventWidget( )\color\frame = colorframe
                  EndIf
               EndIf
            EndIf
            
      EndSelect
      
      If repaint
         ; Debug "change state"
      EndIf
   EndProcedure
   
   
   ;OpenList( *root1 )
   *panel = PanelWidget(20, 20, 180 + 40, 180 + 60) : SetTextWidget(*panel, "1")
   AddItem( *panel, -1, "(enter&leave)-test" )
   
   ContainerWidget(40, 20, 180, 180)                   : SetTextWidget(widget(), "      (PanelWidget(0))") : SetWidgetClass(widget(), "(PanelWidget(0))")
   ContainerWidget(20, 20, 180, 180)                   : SetTextWidget(widget(), "      7") : SetWidgetClass(widget(), "7")
   ContainerWidget(5, 60, 180, 30, #__Flag_NoGadgets)  : SetTextWidget(widget(), "     10") : SetWidgetClass(widget(), "10")
   CloseList( ) ; 7
   CloseList( ) ; (PanelWidget(0))
   Debug "-------------"
   ;
   ContainerWidget(10, 45, 70, 180)                    : SetTextWidget(widget(), "     (PanelWidget(1))") : SetWidgetClass(widget(), "(PanelWidget(1))")
   CloseList( ) ; (PanelWidget(1))
   CloseList( ) ; 1
   
   Show_DEBUG()
;    ;\\
;    OpenList( seven )
;    SetTextWidget(ContainerWidget( - 5, 80, 180, 50, #__Flag_NoGadgets | editable), "container-7")
;    CloseList( ) ; 7
;    
   ;\\
   If *panel\root
      ;PushListPosition( *panel\root\children( ))
      If StartEnum( *panel)
         Bind(widget( ), @events_containers( ), #__event_MouseEnter)
         Bind(widget( ), @events_containers( ), #__event_MouseMove)
         Bind(widget( ), @events_containers( ), #__event_MouseLeave)
         StopEnum( )
      EndIf
      ;PopListPosition( *panel\root\children( ))
   EndIf
   
   
  
   WaitClose( )
   
CompilerEndIf

CompilerIf #PB_Compiler_IsMainFile = 99
  
   
   EnableExplicit
   UseWidgets( )
   
   Global  pos_x = 10
   Global._S_widget *PANEL, *WINDOW, *CONTAINER, *SCROLLAREA, *CONTAINER_0, *SCROLLAREA_0
   Global._S_widget *CHILD, *WINDOW_0, *PANEL0, *PANEL1, *PANEL2, *PANEL_0, *PANEL_1, *PANEL_2
   
   UsePNGImageDecoder()
   
   If Not LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/Background.bmp")
      End
   EndIf
   
   If Not LoadImage(1, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png")
      End
   EndIf
   
   Procedure Show_DEBUG( )
      Define line.s
      ;\\
      Debug "---->>"
      ForEach widgets( )
         ;Debug widgets( )\class
         line = "  "
         
         If widgets( )\BeforeWidget( )
            line + widgets( )\BeforeWidget( )\class +" <<  "    ;  +"_"+widgets( )\BeforeWidget( )\text\string
         Else
            line + "-------- <<  " 
         EndIf
         
         line + widgets( )\class ; widgets( )\text\string
         
         If widgets( )\AfterWidget( )
            line +"  >> "+ widgets( )\AfterWidget( )\class ;+"_"+widgets( )\AfterWidget( )\text\string
         Else
            line + "  >> --------" 
         EndIf
         
         Debug line
      Next
      Debug "<<----"
   EndProcedure
   
   If Open(10, 0, 0, 220, 620, "demo set  new parent", #PB_Window_SystemMenu | #PB_Window_ScreenCentered )
      *PANEL = PanelWidget(10,145,200,160)  : SetWidgetClass(*PANEL, "PANEL") 
      AddItem(*PANEL, -1, "item (0)") : *PANEL_0 = ButtonWidget(pos_x,90,160,30,"(PanelWidget(0))") : SetWidgetClass(*PANEL_0, GetTextWidget(*PANEL_0))
      AddItem(*PANEL, -1, "item (1)") : *PANEL_1 = ButtonWidget(pos_x+5,90,160,30,"(PanelWidget(1))") : SetWidgetClass(*PANEL_1, GetTextWidget(*PANEL_1)) 
      AddItem(*PANEL, -1, "item (2)") : *PANEL_2 = ButtonWidget(pos_x+10,90,160,30,"(PanelWidget(2))") : SetWidgetClass(*PANEL_2, GetTextWidget(*PANEL_2)) 
      CloseList()
      
      
;       Show_DEBUG()
      
      OpenList( *PANEL, 2 )
      *CHILD = ButtonWidget(pos_x,10,160,70,"(CHILD1)") : SetWidgetClass(*CHILD, "CHILD1") 
      CloseList( )
      
       Show_DEBUG()
;       
;       OpenList( *PANEL, 1 )
;       *CHILD = ButtonWidget(pos_x,10,160,70,"(CHILD2)") : SetWidgetClass(*CHILD, "CHILD2") 
;       CloseList( )
;       
;       Show_DEBUG()
;       
;       OpenList( *PANEL, 2 )
;       *CHILD = ButtonWidget(pos_x,10,160,70,"(CHILD3)") : SetWidgetClass(*CHILD, "CHILD3") 
;       CloseList( )
;       
;       Show_DEBUG()
;       
;       
;       ;Debug "^"+root()\FirstWidget( )\class +" "+ root()\last\widget\class +" "+ root()\last\widget\last\widget\class
;       OpenList( root( ), 0 )
;       *CHILD = ButtonWidget(pos_x,10,160,70,"(CHILD4)") : SetWidgetClass(*CHILD, "CHILD4") 
;       CloseList( )
;       
;       Show_DEBUG()
;       
      WaitClose()
   EndIf
CompilerEndIf

; CompilerIf #PB_Compiler_IsMainFile
;    EnableExplicit
;    UseWidgets( )
;    
;    Global._s_WIDGET *CONT, *but
;    
;    If Open( 0, 0, 0, 600, 170, "", #PB_Window_SystemMenu | #PB_Window_ScreenCentered )
;       ;
;       *CONT = ContainerWidget( 10, 10, 200, 150) : SetWidgetClass(widget( ), "CONT1" ) 
;       ButtonWidget( 10,5,80,25, "*btn1_1" )  : SetWidgetClass(widget( ), "btn1_1" ) 
; ;       ButtonWidget( 10,35,80,25, "*btn1_2" )  : SetWidgetClass(widget( ), "btn1_2" ) 
; ;       ButtonWidget( 10,65,80,25, "*btn1_3" )  : SetWidgetClass(widget( ), "btn1_3" ) 
;       CloseList()
; ;       ;
; ;       ContainerWidget( 220, 10, 200, 150) : SetWidgetClass(widget( ), "CONT2" ) 
; ; ;       ButtonWidget( 10,5,80,25, "*btn2_1" )  : SetWidgetClass(widget( ), "btn2_1" ) 
; ; ;       ButtonWidget( 10,35,80,25, "*btn2_2" )  : SetWidgetClass(widget( ), "btn2_2" ) 
; ; ;       ButtonWidget( 10,65,80,25, "*btn2_3" )  : SetWidgetClass(widget( ), "btn2_3" ) 
; ;       CloseList()
; ;       ;
; ;       ContainerWidget( 430, 10, 200, 150) : SetWidgetClass(widget( ), "CONT3" ) 
; ; ;       ButtonWidget( 10,5,80,25, "*btn3_1" )  : SetWidgetClass(widget( ), "btn3_1" ) 
; ; ;       ButtonWidget( 10,35,80,25, "btn3_2" )  : SetWidgetClass(widget( ), "btn3_2" ) 
; ; ;       ButtonWidget( 10,65,80,25, "*btn3_3" )  : SetWidgetClass(widget( ), "btn3_3" ) 
; ;       CloseList()
;       
;       
;       ; *but = ButtonWidget( 100,35,80,25, "*btn1_added" ) : SetWidgetClass(widget( ), "btn1_added" ) 
;       ButtonWidget( 100,35,80,25, "*btn77" ) : SetWidgetClass(widget( ), "btn77" ) 
;       
;       ;\\
;       ;SetParent( *but, *CONT, 0 )
;       OpenList( *CONT )
;       *but = ButtonWidget(100,35,80,25,"*btn1_added") : SetWidgetClass(*but, "btn1_added") 
;       CloseList( )
;       
;       ;       ;\\
; ;       SetPosition( *but0, #PB_List_Before )
; ;       SetPosition( *but0, #PB_List_Before )
; ;       SetPosition( *but0, #PB_List_Before )
; ;   
;       
;       Debug "----CONT all childrens-----"
;       If StartEnum( *CONT )
;          Debug widget( )\text\string
;          
;          StopEnum( )
;       EndIf
;       
;       Debug "----all childrens-----"
;       ForEach widgets( )
;          Debug  widgets( )\class
;       Next
;       
;       ;\\
;       Define line.s
;       Debug "---->>"
;       ForEach widgets( )
;          line = "  ";+ widgets( )\class +" "
;          
;          If widgets( )\BeforeWidget( )
;             line + widgets( )\BeforeWidget( )\class +" <<  "    ;  +"_"+widgets( )\BeforeWidget( )\text\string
;          Else
;             line + "-------- <<  " 
;          EndIf
;          
;          line + widgets( )\class ; widgets( )\text\string
;          
;          If widgets( )\AfterWidget( )
;             line +"  >> "+ widgets( )\AfterWidget( )\class ;+"_"+widgets( )\AfterWidget( )\text\string
;          Else
;             line + "  >> --------" 
;          EndIf
;          
;          Debug line
;       Next
;       Debug "<<----"
;       
;      
;       WaitClose( )
;    EndIf   
; CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 67
; FirstLine = 63
; Folding = ------
; EnableXP
; DPIAware
; DisableDebugger