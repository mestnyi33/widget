﻿; IncludePath "../../../"
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
;    If Open( #PB_Any, 0, 0, x+170, 170, "", #PB_Window_SystemMenu | #PB_Window_ScreenCentered )
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
;       SetGadgetState( panel, 2 )
;       
;       ;\\
;       *root = root()
;       ;     ;*root = Window( x, 0, 160,170-10, "") :x = 0
;       ;     *root = Container( x, 0, 160,170-10) :x = 0
;       
;       *panel = Panel( x, 65, 160,95 ) 
;          i=0:AddItem( *panel, i, Hex(i) ) : Button( 10,5,80,35, "_"+Str(i) )  : SetClass(widget( ), "btn"+Str(i) )  
;          i=1:AddItem( *panel, i, Hex(i) ) : Button( 10,5,80,35, "_"+Str(i) )  : SetClass(widget( ), "btn"+Str(i) ) 
;          i=2:AddItem( *panel, i, Hex(i) ) : Button( 10,5,80,35, "_"+Str(i) )  : SetClass(widget( ), "btn"+Str(i) ) 
;          i=3:AddItem( *panel, i, Hex(i) ) : Button( 10,5,80,35, "_"+Str(i) )  : SetClass(widget( ), "btn"+Str(i) ) 
;          i=4:AddItem( *panel, i, Hex(i) ) : Button( 10,5,80,35, "_"+Str(i) )  : SetClass(widget( ), "btn"+Str(i) ) 
;          i=5:AddItem( *panel, i, Hex(i) ) : Button( 10,5,80,35, "_"+Str(i) )  : SetClass(widget( ), "btn"+Str(i) ) 
;       CloseList( )
;       
; ;           OpenList( *panel, 0 )
; ;           Button( 20,25,80,35, "_0" ) : SetClass(widget( ), "btn"+Str(0) )  
; ;           CloseList( )
;       
;        *butt0 = Button( 20,25,80,35, "_0" ) : SetClass(widget( ), "btn"+Str(0) ) 
;        Debug " reparent "
;        SetParent( *butt0, *panel, 0 )
;       
; ;       ;
; ;       *butt1 = Button( x,5,80,25, "*butt1" ) 
; ;       *butt2 = Button( x,35,80,25, "*butt2" ) 
; ;       
; ;       If *panel
; ;          SetState( *panel, 2 )
; ;       EndIf
; ;       
;       Debug "----panel all childrens-----"
;       If StartEnum( *panel )
;          Debug widget( )\txt\string
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
;             line + widgets( )\BeforeWidget( )\class +" <<  "    ;  +"_"+widgets( )\BeforeWidget( )\txt\string
;          Else
;             line + "-------- <<  " 
;          EndIf
;          
;          line + widgets( )\class ; widgets( )\txt\string
;          
;          If widgets( )\AfterWidget( )
;             line +"  >> "+ widgets( )\AfterWidget( )\class ;+"_"+widgets( )\AfterWidget( )\txt\string
;          Else
;             line + "  >> --------" 
;          EndIf
;          
;          Debug line
;       Next
;       Debug "<<----"
;       
;       
;       Debug ""+*panel\FirstWidget( )\class +" <<<< "+ *panel\class +" >>>> "+ *panel\LastWidget( )\class
;       
;       CompilerIf #PB_Compiler_OS = #PB_OS_Windows
;          ClipGadgets( UseGadgetList(0) )
;       CompilerEndIf
;       Repeat: Until WaitWindowEvent() = #PB_Event_CloseWindow
;    EndIf   
; CompilerEndIf




IncludePath "../../../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
   Global._s_WIDGET *CONT, *but0
   
   If Open( 0, 0, 0, 220, 170, "", #PB_Window_SystemMenu | #PB_Window_ScreenCentered )
      ;
      *CONT = Panel( 10, 10, 200, 150) : SetClass(widget( ), "CONT1" ) 
      AddItem(*CONT, -1, "item0" )
      ;
      AddItem(*CONT, -1, "item1" )
      Button( 10,5,80,25, "*btn1_1" )  : SetClass(widget( ), "btn1_1" ) 
;       Button( 10,35,80,25, "*btn1_2" )  : SetClass(widget( ), "btn1_2" ) 
;       Button( 10,65,80,25, "*btn1_3" )  : SetClass(widget( ), "btn1_3" ) 
; ;       ;
;       AddItem(*CONT, -1, "item2" )
;       Button( 10,5,80,25, "*btn2_4" )  : SetClass(widget( ), "btn2_4" ) 
;       Button( 10,35,80,25, "*btn2_5" )  : SetClass(widget( ), "btn2_5" ) 
;       Button( 10,65,80,25, "*btn2_6" )  : SetClass(widget( ), "btn2_6" ) 
;       ;
;       AddItem(*CONT, -1, "item3" )
;       Button( 10,5,80,25, "*btn3_7" )  : SetClass(widget( ), "btn3_7" ) 
;       Button( 10,35,80,25, "*btn3_8" )  : SetClass(widget( ), "btn3_8" ) 
;       Button( 10,65,80,25, "*btn3_9" )  : SetClass(widget( ), "btn3_9" ) 
      ;
      CloseList()
      
      ;\\ test 
      *but0 = Button( 100,35,80,25, "*btn0_added" ) : SetClass(widget( ), "btn0_added" ) 
      Button( 100,35,80,25, "*btn77" ) : SetClass(widget( ), "btn77" ) 
      
      ;\\
      Debug " reParent       "
      SetParent( *but0, *CONT, 0 )
      
      Debug "----CONT all childrens-----"
      If StartEnum( *CONT )
         Debug widget( )\txt\string
         
         StopEnum( )
      EndIf
      
      Debug "----all childrens-----"
      ForEach widgets( )
         Debug  ""+widgets( )\class ;+" "+ widgets( )\FirstWidget( ) +" "+ widgets( )\BeforeWidget( ) +" "+ widgets( )\AfterWidget( ) +" "+ widgets( )\LastWidget( )
      Next
      
      ;\\ 
      Define line.s
      Debug "---->>"
      ForEach widgets( )
         line = "  ";+ widgets( )\class +" "
         
         If widgets( )\BeforeWidget( )
            line + widgets( )\BeforeWidget( )\class +" <<  "    ;  +"_"+widgets( )\BeforeWidget( )\txt\string
         Else
            line + "-------- <<  " 
         EndIf
         
         line + widgets( )\class ; widgets( )\txt\string
         
         If widgets( )\AfterWidget( )
            line +"  >> "+ widgets( )\AfterWidget( )\class ;+"_"+widgets( )\AfterWidget( )\txt\string
         Else
            line + "  >> --------" 
         EndIf
         
         Debug line
      Next
      Debug "<<----"
      
      Debug ""+root()\FirstWidget( )\class +" <<<< "+ root()\class +" >>>> "+ root()\lastWidget( )\class
      
      ;\\
      ;       result
      
      WaitClose( )
   EndIf   
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 107
; FirstLine = 99
; Folding = -
; EnableXP