; IncludePath "../../../"
; CompilerIf #PB_Compiler_OS = #PB_OS_Windows
;    XIncludeFile "include/os/win/id.pbi"
;    XIncludeFile "include/os/win/ClipGadgets.pbi"
; CompilerEndIf
; XIncludeFile "widgets.pbi"
; 
; CompilerIf #PB_Compiler_IsMainFile
;    EnableExplicit
;    UseWidgets( )
;    
;    Global i, x = 220, panel, butt1, butt2
;    Global._s_WIDGET *root, *panel, *butt0, *butt1, *butt2
;    
;    If OpenRoot( #PB_Any, 0, 0, x+170, 170, "", #PB_Window_SystemMenu | #PB_Window_ScreenCentered )
;       ;\\
;       panel = PanelGadget(#PB_Any, 10, 65, 160,95 ) 
;       For i = 0 To 5 
;          AddGadgetItem( panel, i, Hex(i) ) 
;          If i
;             ButtonGadget(#PB_Any, 10,5,80,35, "_"+Str(i) )
;          EndIf
;       Next 
;       CloseGadgetList( )
;       ;
;       OpenGadgetList( panel, 0 )
;       ButtonGadget(#PB_Any, 20,25,80,35, "_0" ) 
;       CloseGadgetList( )
;       ;
;       butt1 = ButtonGadget(#PB_Any, 10,5,80,25, "*butt1" ) 
;       butt2 = ButtonGadget(#PB_Any, 10,35,80,25, "*butt2" ) 
;       ;
;       SetGadGetWidgetState( panel, 2 )
;       
;       ;\\
;       *root = root()
;       ;     ;*root = WindowWidget( x, 0, 160,170-10, "") :x = 0
;       ;     *root = ContainerWidget( x, 0, 160,170-10) :x = 0
;       
;       *panel = PanelWidget( x, 65, 160,95 ) 
;          i=0:AddItem( *panel, i, Hex(i) ) : ButtonWidget( 10,5,80,35, "_"+Str(i) )  : SetWidgetClass(widget( ), "btn"+Str(i) )  
;          i=1:AddItem( *panel, i, Hex(i) ) : ButtonWidget( 10,5,80,35, "_"+Str(i) )  : SetWidgetClass(widget( ), "btn"+Str(i) ) 
;          i=2:AddItem( *panel, i, Hex(i) ) : ButtonWidget( 10,5,80,35, "_"+Str(i) )  : SetWidgetClass(widget( ), "btn"+Str(i) ) 
;          i=3:AddItem( *panel, i, Hex(i) ) : ButtonWidget( 10,5,80,35, "_"+Str(i) )  : SetWidgetClass(widget( ), "btn"+Str(i) ) 
;          i=4:AddItem( *panel, i, Hex(i) ) : ButtonWidget( 10,5,80,35, "_"+Str(i) )  : SetWidgetClass(widget( ), "btn"+Str(i) ) 
;          i=5:AddItem( *panel, i, Hex(i) ) : ButtonWidget( 10,5,80,35, "_"+Str(i) )  : SetWidgetClass(widget( ), "btn"+Str(i) ) 
;       CloseWidgetList( )
;       
; ;           OpenWidgetList( *panel, 0 )
; ;           ButtonWidget( 20,25,80,35, "_0" ) : SetWidgetClass(widget( ), "btn"+Str(0) )  
; ;           CloseWidgetList( )
;       
;        *butt0 = ButtonWidget( 20,25,80,35, "_0" ) : SetWidgetClass(widget( ), "btn"+Str(0) ) 
;        Debug " reparent "
;        SetParent( *butt0, *panel, 0 )
;       
; ;       ;
; ;       *butt1 = ButtonWidget( x,5,80,25, "*butt1" ) 
; ;       *butt2 = ButtonWidget( x,35,80,25, "*butt2" ) 
; ;       
; ;       If *panel
; ;          SetWidgetState( *panel, 2 )
; ;       EndIf
; ;       
;       Debug "----panel all childrens-----"
;       If StartEnum( *panel )
;          Debug widget( )\text\string
;          
;          StopEnum( )
;       EndIf
;       
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
;       Debug ""+*panel\FirstWidget( )\class +" <<<< "+ *panel\class +" >>>> "+ *panel\last\widget\class
;       
;       CompilerIf #PB_Compiler_OS = #PB_OS_Windows
;          ClipGadgets( UseGadgetList(0) )
;       CompilerEndIf
;       Repeat: Until WaitWindowEvent() = #PB_Event_CloseWindow
;    EndIf   
; CompilerEndIf




IncludePath "../../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
   Global._s_WIDGET *CONT, *but0
   
   If OpenRoot( 0, 0, 0, 220, 170, "", #PB_Window_SystemMenu | #PB_Window_ScreenCentered )
      ;
      *CONT = PanelWidget( 10, 10, 200, 150) : SetWidgetClass(widget( ), "CONT1" ) 
      AddItem(*CONT, -1, "item0" )
      ;
      AddItem(*CONT, -1, "item1" )
      ButtonWidget( 10,5,80,25, "*btn1_1" )  : SetWidgetClass(widget( ), "btn1_1" ) 
;       ButtonWidget( 10,35,80,25, "*btn1_2" )  : SetWidgetClass(widget( ), "btn1_2" ) 
;       ButtonWidget( 10,65,80,25, "*btn1_3" )  : SetWidgetClass(widget( ), "btn1_3" ) 
; ;       ;
;       AddItem(*CONT, -1, "item2" )
;       ButtonWidget( 10,5,80,25, "*btn2_4" )  : SetWidgetClass(widget( ), "btn2_4" ) 
;       ButtonWidget( 10,35,80,25, "*btn2_5" )  : SetWidgetClass(widget( ), "btn2_5" ) 
;       ButtonWidget( 10,65,80,25, "*btn2_6" )  : SetWidgetClass(widget( ), "btn2_6" ) 
;       ;
;       AddItem(*CONT, -1, "item3" )
;       ButtonWidget( 10,5,80,25, "*btn3_7" )  : SetWidgetClass(widget( ), "btn3_7" ) 
;       ButtonWidget( 10,35,80,25, "*btn3_8" )  : SetWidgetClass(widget( ), "btn3_8" ) 
;       ButtonWidget( 10,65,80,25, "*btn3_9" )  : SetWidgetClass(widget( ), "btn3_9" ) 
      ;
      CloseWidgetList()
      
      ;\\ test 
      *but0 = ButtonWidget( 100,35,80,25, "*btn0_added" ) : SetWidgetClass(widget( ), "btn0_added" ) 
      ButtonWidget( 100,35,80,25, "*btn77" ) : SetWidgetClass(widget( ), "btn77" ) 
      
      ;\\
      Debug " reParent       "
      SetParent( *but0, *CONT, 0 )
      
      Debug "----CONT all childrens-----"
      If StartEnum( *CONT )
         Debug widget( )\text\string
         
         StopEnum( )
      EndIf
      
      Debug "----all childrens-----"
      ForEach widgets( )
         Debug  ""+widgets( )\class ;+" "+ widgets( )\FirstWidget( ) +" "+ widgets( )\BeforeWidget( ) +" "+ widgets( )\AfterWidget( ) +" "+ widgets( )\last\widget
      Next
      
      ;\\ 
      Define line.s
      Debug "---->>"
      ForEach widgets( )
         line = "  ";+ widgets( )\class +" "
         
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
      
      Debug ""+root()\FirstWidget( )\class +" <<<< "+ root()\class +" >>>> "+ root()\lastWidget( )\class
      
      ;\\
      ;       result
      
      WaitCloseRoot( )
   EndIf   
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 182
; FirstLine = 164
; Folding = -
; EnableXP