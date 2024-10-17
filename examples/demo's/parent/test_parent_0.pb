IncludePath "../../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
   
   EnableExplicit
   UseLIB(widget)
   
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
         
         If widgets( )\before\widget
            line + widgets( )\before\widget\class +" <<  "    ;  +"_"+widgets( )\before\widget\text\string
         Else
            line + "-------- <<  " 
         EndIf
         
         line + widgets( )\class ; widgets( )\text\string
         
         If widgets( )\after\widget
            line +"  >> "+ widgets( )\after\widget\class ;+"_"+widgets( )\after\widget\text\string
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
   Define *root1._s_WIDGET = Open(#window, 300, 10, 300 - 20, 300 - 20): *root1\class = "root1": SetText(*root1, "root1")
   ;BindWidgetEvent( *root1, @HandlerEvents( ) )
   
  
   
   
   Define *g,editable,a,count = 2;0000
   #st          = 1
   Global mx    = #st, my = #st
   
   Define time = ElapsedMilliseconds( )
   
   Global *c, *p, *panel._s_WIDGET
   Procedure do_Events( )
      Select WidgetEvent( )
         Case #__event_LeftClick
            
            Select GetText( EventWidget( ) )
               Case "hide_children"
                  hide(*p, 1)
                  ; Disable(*c, 1)
                  
               Case "show_children"
                  hide(*p, 0)
                  
               Case "hide_parent"
                  hide(*c, GetState( EventWidget( ) ))
                  
            EndSelect
            
            ;         ;Case #__event_LeftButtonUp
            ;         ClearDebugOutput( )
            ; PushListPosition( panel_children( ))
            ;         If StartEnumerate(*panel);Root( ))
            ;           If Not hide(widget( )) ;And GetParent(widget( )) = *panel
            ;             Debug " class - " + widget( )\Class ;+" ("+ widget( )\item +" - parent_item)"
            ;           EndIf
            ;           StopEnumerate( )
            ;         EndIf
            ; PopListPosition( panel_children( ))
            
            
      EndSelect
   EndProcedure
   
   OpenList( *root1 )
   *panel = Panel(20, 20, 180 + 40, 180 + 60, editable) : SetText(*panel, "1")
   AddItem( *panel, -1, "item_1" )
   
   AddItem( *panel, -1, "(hide&show)-test" )
   
   *c = Panel(110, 5, 150, 155)
    AddItem(*c, -1, "0")
   
;    *p = Panel(10, 5, 150, 65)
;    AddItem(*p, -1, "item-1")
; ;    Container(10, 5, 150, 55, #PB_Container_Flat)
; ; ;    Container(10, 5, 150, 55, #PB_Container_Flat)
   Button(10, 5, 50, 25, "butt1")
; ; ;    CloseList( )
; ;    CloseList( )
; ; ;    AddItem(*p, -1, "item-2")
; ; ;    Container(10, 5, 150, 55, #PB_Container_Flat)
; ; ;    Container(10, 5, 150, 55, #PB_Container_Flat)
; ; ;    Button(10, 5, 50, 25, "butt2")
; ; ;    CloseList( )
; ; ;    CloseList( )
; ; ;    AddItem(*c, -1, "1")
;    CloseList( )
   
;    Container(10, 75, 150, 55, #PB_Container_Flat)
;    Container(10, 5, 150, 55, #PB_Container_Flat)
;    Container(10, 5, 150, 55, #PB_Container_Flat)
;    Button(10, 5, 50, 45, "butt1")
;    CloseList( )
;    CloseList( )
;    CloseList( )
   CloseList( )
   
   Show_DEBUG( )

   WaitClose( )
   
CompilerEndIf


CompilerIf #PB_Compiler_IsMainFile = 99
   
   EnableExplicit
   UseLIB(widget)
   
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
         
         If widgets( )\before\widget
            line + widgets( )\before\widget\class +" <<  "    ;  +"_"+widgets( )\before\widget\text\string
         Else
            line + "-------- <<  " 
         EndIf
         
         line + widgets( )\class ; widgets( )\text\string
         
         If widgets( )\after\widget
            line +"  >> "+ widgets( )\after\widget\class ;+"_"+widgets( )\after\widget\text\string
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
   Define *root1._s_WIDGET = root( ): *root1\class = "root1": SetText(*root1, "root1")
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
            
            If EventWidget( ) <> Root( )
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
   *panel = Panel(20, 20, 180 + 40, 180 + 60) : SetText(*panel, "1")
   AddItem( *panel, -1, "(enter&leave)-test" )
   
   Container(40, 20, 180, 180)                   : SetText(widget(), "      (Panel(0))") : SetClass(widget(), "(Panel(0))")
   Container(20, 20, 180, 180)                   : SetText(widget(), "      7") : SetClass(widget(), "7")
   Container(5, 60, 180, 30, #__Flag_NoGadgets)  : SetText(widget(), "     10") : SetClass(widget(), "10")
   CloseList( ) ; 7
   CloseList( ) ; (Panel(0))
   Debug "-------------"
   ;
   Container(10, 45, 70, 180)                    : SetText(widget(), "     (Panel(1))") : SetClass(widget(), "(Panel(1))")
   CloseList( ) ; (Panel(1))
   CloseList( ) ; 1
   
   Show_DEBUG()
;    ;\\
;    OpenList( seven )
;    SetText(Container( - 5, 80, 180, 50, #__Flag_NoGadgets | editable), "container-7")
;    CloseList( ) ; 7
;    
   ;\\
   If *panel\root
      ;PushListPosition( *panel\root\children( ))
      If StartEnumerate( *panel)
         Bind(widget( ), @events_containers( ), #__event_MouseEnter)
         Bind(widget( ), @events_containers( ), #__event_MouseMove)
         Bind(widget( ), @events_containers( ), #__event_MouseLeave)
         StopEnumerate( )
      EndIf
      ;PopListPosition( *panel\root\children( ))
   EndIf
   
   
  
   WaitClose( )
   
CompilerEndIf

CompilerIf #PB_Compiler_IsMainFile = 99
  
   
   EnableExplicit
   UseLib(widget)
   
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
         
         If widgets( )\before\widget
            line + widgets( )\before\widget\class +" <<  "    ;  +"_"+widgets( )\before\widget\text\string
         Else
            line + "-------- <<  " 
         EndIf
         
         line + widgets( )\class ; widgets( )\text\string
         
         If widgets( )\after\widget
            line +"  >> "+ widgets( )\after\widget\class ;+"_"+widgets( )\after\widget\text\string
         Else
            line + "  >> --------" 
         EndIf
         
         Debug line
      Next
      Debug "<<----"
   EndProcedure
   
   If Open(10, 0, 0, 220, 620, "demo set  new parent", #PB_Window_SystemMenu | #PB_Window_ScreenCentered )
      *PANEL = Panel(10,145,200,160)  : SetClass(*PANEL, "PANEL") 
      AddItem(*PANEL, -1, "item (0)") : *PANEL_0 = Button(pos_x,90,160,30,"(Panel(0))") : SetClass(*PANEL_0, GetText(*PANEL_0))
      AddItem(*PANEL, -1, "item (1)") : *PANEL_1 = Button(pos_x+5,90,160,30,"(Panel(1))") : SetClass(*PANEL_1, GetText(*PANEL_1)) 
      AddItem(*PANEL, -1, "item (2)") : *PANEL_2 = Button(pos_x+10,90,160,30,"(Panel(2))") : SetClass(*PANEL_2, GetText(*PANEL_2)) 
      CloseList()
      
      
;       Show_DEBUG()
      
      OpenList( *PANEL, 2 )
      *CHILD = Button(pos_x,10,160,70,"(CHILD1)") : SetClass(*CHILD, "CHILD1") 
      CloseList( )
      
       Show_DEBUG()
;       
;       OpenList( *PANEL, 1 )
;       *CHILD = Button(pos_x,10,160,70,"(CHILD2)") : SetClass(*CHILD, "CHILD2") 
;       CloseList( )
;       
;       Show_DEBUG()
;       
;       OpenList( *PANEL, 2 )
;       *CHILD = Button(pos_x,10,160,70,"(CHILD3)") : SetClass(*CHILD, "CHILD3") 
;       CloseList( )
;       
;       Show_DEBUG()
;       
;       
;       ;Debug "^"+root()\first\widget\class +" "+ root()\last\widget\class +" "+ root()\last\widget\last\widget\class
;       OpenList( root( ), 0 )
;       *CHILD = Button(pos_x,10,160,70,"(CHILD4)") : SetClass(*CHILD, "CHILD4") 
;       CloseList( )
;       
;       Show_DEBUG()
;       
      WaitClose()
   EndIf
CompilerEndIf

; CompilerIf #PB_Compiler_IsMainFile
;    EnableExplicit
;    UseLib(widget)
;    
;    Global._s_WIDGET *CONT, *but
;    
;    If Open( 0, 0, 0, 600, 170, "", #PB_Window_SystemMenu | #PB_Window_ScreenCentered )
;       ;
;       *CONT = Container( 10, 10, 200, 150) : SetClass(widget( ), "CONT1" ) 
;       Button( 10,5,80,25, "*btn1_1" )  : SetClass(widget( ), "btn1_1" ) 
; ;       Button( 10,35,80,25, "*btn1_2" )  : SetClass(widget( ), "btn1_2" ) 
; ;       Button( 10,65,80,25, "*btn1_3" )  : SetClass(widget( ), "btn1_3" ) 
;       CloseList()
; ;       ;
; ;       Container( 220, 10, 200, 150) : SetClass(widget( ), "CONT2" ) 
; ; ;       Button( 10,5,80,25, "*btn2_1" )  : SetClass(widget( ), "btn2_1" ) 
; ; ;       Button( 10,35,80,25, "*btn2_2" )  : SetClass(widget( ), "btn2_2" ) 
; ; ;       Button( 10,65,80,25, "*btn2_3" )  : SetClass(widget( ), "btn2_3" ) 
; ;       CloseList()
; ;       ;
; ;       Container( 430, 10, 200, 150) : SetClass(widget( ), "CONT3" ) 
; ; ;       Button( 10,5,80,25, "*btn3_1" )  : SetClass(widget( ), "btn3_1" ) 
; ; ;       Button( 10,35,80,25, "btn3_2" )  : SetClass(widget( ), "btn3_2" ) 
; ; ;       Button( 10,65,80,25, "*btn3_3" )  : SetClass(widget( ), "btn3_3" ) 
; ;       CloseList()
;       
;       
;       ; *but = Button( 100,35,80,25, "*btn1_added" ) : SetClass(widget( ), "btn1_added" ) 
;       Button( 100,35,80,25, "*btn77" ) : SetClass(widget( ), "btn77" ) 
;       
;       ;\\
;       ;SetParent( *but, *CONT, 0 )
;       OpenList( *CONT )
;       *but = Button(100,35,80,25,"*btn1_added") : SetClass(*but, "btn1_added") 
;       CloseList( )
;       
;       ;       ;\\
; ;       SetPosition( *but0, #PB_List_Before )
; ;       SetPosition( *but0, #PB_List_Before )
; ;       SetPosition( *but0, #PB_List_Before )
; ;   
;       
;       Debug "----CONT all childrens-----"
;       If StartEnumerate( *CONT )
;          Debug widget( )\text\string
;          
;          StopEnumerate( )
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
;          If widgets( )\before\widget
;             line + widgets( )\before\widget\class +" <<  "    ;  +"_"+widgets( )\before\widget\text\string
;          Else
;             line + "-------- <<  " 
;          EndIf
;          
;          line + widgets( )\class ; widgets( )\text\string
;          
;          If widgets( )\after\widget
;             line +"  >> "+ widgets( )\after\widget\class ;+"_"+widgets( )\after\widget\text\string
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
; CursorPosition = 179
; FirstLine = 144
; Folding = ------
; EnableXP
; DPIAware