 XIncludeFile "../../widgets.pbi"
; fixed 778 commit
;-
 
 CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  Uselib(widget)
  
  Global object, parent
  Declare CustomEvents( )
  
  ;\\
  Open(0, 0, 0, 600, 600, "Demo bounds", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_SizeGadget)
  a_init(root(), 4)
  Define i,fs = 10
  ;\\
  ; parent = Window(50, 50, 500, 500, "parent", #PB_Window_SystemMenu)
  ; parent = Window(50, 50, 500, 500, "parent", #PB_Window_BorderLess)
  parent = Container(50, 50, 500, 500)
;   widget()\fs = fs : Resize(widget(), #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
;   SetColor(parent, #__color_back, $FFE9E9E9)
  
  Define text.s = "object"+#LF$+" multiline "+#LF$+"text"
  ;\\
  ;object = Window(100, 100, 250, 220, "Resize me !", #PB_Window_SystemMenu | #PB_Window_SizeGadget, parent)
  ;object = Container(100, 100, 250, 250) : CloseList( )
  ;object = String(100, 100, 250, 250, text, #__flag_textwordwrap|#__flag_textcenter)
  ;object = Button(100, 100, 250, 250, text, #__flag_textmultiline);, #__flag_borderless)
  ;object = Button(100, 100, 250, 250, text, #__flag_textwordwrap);, #__flag_borderless)
  object = Editor(100, 100, 250, 250, #__flag_textwordwrap|#__flag_textcenter) : SetText(object, text)
  ;object = Tree(100, 100, 250, 250) : For i=0 To 10 : additem(object,-1, "tree element line "+Str(i)) : Next
   
; ;   ;\\
;    widget()\fs = 50 : Resize(widget(), #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
;   
;   ;\\
;   Define anchor_size = 30
;   a_set(parent, #__a_full, anchor_size/2)
;   a_set(object, #__a_full, anchor_size)
; ;   a_set(object, #__a_full, anchor_size*2)
; ;   a_set(object, #__a_full, anchor_size*2, 5)
; ;   a_set(object, #__a_full, anchor_size)
;   
;   ;\\
;   SizeBounds(object, anchor_size*2, anchor_size*2, 460, 460)
;   ;MoveBounds(object, fs, fs, 501-fs, 501-fs)
;   MoveBounds(object, 0, 0, 501-fs*2, 501-fs*2)
;   
  ;\\
  Bind( parent, @CustomEvents(), #__event_statuschange )
  Bind( parent, @CustomEvents(), #__event_resize )
  
  ;\\
  Bind( object, @CustomEvents(), #__event_statuschange )
  Bind( object, @CustomEvents(), #__event_resize )
  WaitClose( )
  
  ;\\
  Procedure CustomEvents( )
    Select WidgetEvent( )
          
       Case #__event_statuschange
          If EventWidget( )\hide=0;show
             Debug "statuschange "
          EndIf
          
       Case #__event_resize
         ; Debug "resize "+EventWidget( )\class +" "+ EventWidget( )\frame_width( ) +" "+ EventWidget( )\frame_height( )
          
    EndSelect
 EndProcedure
 
CompilerEndIf

; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 62
; FirstLine = 49
; Folding = -
; EnableXP
; DPIAware