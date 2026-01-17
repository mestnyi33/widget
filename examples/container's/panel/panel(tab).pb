IncludePath "../../../"
XIncludeFile "widgets.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
   ;test_clip = 1
   ;test_iclip = 1
   
   Global._s_WIDGEt *g, *g1, *g2, *g3, *g4, *g5, *g6, *g7, *g8
   Define img_new = LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/New.png")
   Define img_open = LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Open.png")
   Define img_save = LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Save.png")
   If DesktopResolutionX() = 2.0
      ResizeImage(img_new,32,32)
      ResizeImage(img_open,32,32)
      ResizeImage(img_save,32,32)
   EndIf
   img_new =- 1
   ;img_open =- 1
   img_save =- 1
   
   Procedure all_events()
      Select EventWidget()
         Case *g1, *g2, *g3, *g4
            Static._s_WIDGET *d
            
            Select WidgetEvent( )
               Case #__event_DragStart
                  *d = EventWidget( )
                  
               Case #__event_LeftUp
                  *d = 0
                  
               Case #__event_MouseMove
                  If *d 
                     Resize(*d, MouseMoveX( ), MouseMoveY( ), #PB_Ignore, #PB_Ignore)
                     Debug " - "+*d\clip_x() +" "+*d\clip_y() +" "+*d\clip_width() +" "+*d\clip_height()
                     Debug "   i - "+*d\clip_ix() +" "+*d\clip_iy() +" "+*d\clip_iwidth() +" "+*d\clip_iheight()
                  EndIf
                  
            EndSelect
            
      EndSelect
   EndProcedure
   
   If Open(0, 270, 100, 890, 470, "Change tab location")
      
      *g = Container(10, 10, 870, 450) 
      SetFrame( *g, 10 )
      ;a_init(*g)
      
      *g1 = Panel(10, 10, 200, 95) 
      AddItem(*g1, 0, "1", img_new )
      Button(0,0,GetAttribute(*g1, #PB_Panel_ItemWidth),GetAttribute(*g1, #PB_Panel_ItemHeight),"")
      AddItem(*g1, 1, "open top item", img_open, #PB_ToolBar_Normal)
      AddItem(*g1, 2, "2g", img_save )
      CloseList() ; *g1
      
      *g2 = Panel(10, 115, 200, 95, #__flag_Invert)
      AddItem(*g2, 0, "1", img_new )
      Button(0,0,GetAttribute(*g2, #PB_Panel_ItemWidth),GetAttribute(*g2, #PB_Panel_ItemHeight),"")
      AddItem(*g2, 1, "open bottom item", img_open, #PB_ToolBar_Normal)
      AddItem(*g2, 2, "2g", img_save )
      CloseList() ; *g2
      
      *g3 = Panel(10, 220, 95, 200, #__flag_Vertical)
      AddItem(*g3, 0, "1", img_new )
      Button(0,0,GetAttribute(*g3, #PB_Panel_ItemWidth),GetAttribute(*g3, #PB_Panel_ItemHeight),"")
      AddItem(*g3, 1, "open left item", img_open, #PB_ToolBar_Normal)
      AddItem(*g3, 2, "2g", img_save )
      CloseList() ; *g3
      
      *g4 = Panel(115, 220, 95, 200, #__flag_Vertical|#__flag_Invert)
      AddItem(*g4, 0, "1", img_new )
      Button(0,0,GetAttribute(*g4, #PB_Panel_ItemWidth),GetAttribute(*g4, #PB_Panel_ItemHeight),"")
      AddItem(*g4, 1, "open right item", img_open);, #PB_ToolBar_Normal)
      AddItem(*g4, 2, "2g", img_save )
      CloseList() ; *g4
      
      ;
      ;\\
      ;
      *g5 = Panel(220, 10, 200, 200, #__flag_Vertical)
      ;SetFrame( *g5, 10 )
      AddItem(*g5, 0, "1", img_new )
      Button(0,0,GetAttribute(*g5, #PB_Panel_ItemWidth),GetAttribute(*g5, #PB_Panel_ItemHeight),"")
      AddItem(*g5, 1, "open left", img_open, #PB_ToolBar_Normal)
      ScrollArea(10,10,140,140, 180,180,1) 
      Button(10,10,40,40,"")
      CloseList( )
      AddItem(*g5, 2, "2g", img_save )
      CloseList() ; *g5
;       
;      *g6 = Panel(220, 220, 200, 200, #__flag_Vertical)
;       ;SetFrame( *g6, 10 )
;       AddItem(*g6, 0, "1", img_new )
;       Button(0,0,GetAttribute(*g6, #PB_Panel_ItemWidth),GetAttribute(*g6, #PB_Panel_ItemHeight),"")
;       AddItem(*g6, 1, "open item", img_open, #PB_ToolBar_Normal)
;       AddItem(*g6, 2, "2g", img_save )
;       CloseList() ; *g6
;       
;       ;       Debug ""+*g3\clip_x() +" "+*g3\clip_y() +" "+*g3\clip_width() +" "+*g3\clip_height()
; ;       Debug ""+*g3\clip_ix() +" "+*g3\clip_iy() +" "+*g3\clip_iwidth() +" "+*g3\clip_iheight()
; ; ;       Debug ""+*g3\tabbar\clip_x() +" "+*g3\tabbar\clip_y() +" "+*g3\tabbar\clip_width() +" "+*g3\tabbar\clip_height()
; ; ;       Debug ""+*g3\tabbar\clip_ix() +" "+*g3\tabbar\clip_iy() +" "+*g3\tabbar\clip_iwidth() +" "+*g3\tabbar\clip_iheight()
      

      Bind(#PB_All, @all_events())
      Repeat
         Select WaitWindowEvent()
            Case #PB_Event_CloseWindow
               Break
               
         EndSelect
      ForEver
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.21 - C Backend (MacOS X - x64)
; CursorPosition = 85
; FirstLine = 53
; Folding = 8-
; EnableXP
; DPIAware